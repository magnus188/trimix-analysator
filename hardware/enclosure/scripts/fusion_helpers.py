"""Small, parametric Fusion helpers; import and run only inside Autodesk Fusion.

Length arguments are Fusion expression strings, preferably explicit ``mm`` or
length user-parameter names. Initial geometry is evaluated in Fusion's internal
centimetres, while dimensions retain the supplied expressions. Sketches use a
component's coordinates, and offset planes retain their position expressions.
YZ/XZ helpers derive their local coordinate mapping from Fusion, rather than
assuming the sketch axes match the names of the origin construction planes.

Coordinates that evaluate to zero are anchored to their corresponding origin
axis, rather than given a degenerate zero dimension. Use literal ``0 mm`` for
these coordinates. Nonzero coordinates and extrusion distances must retain
their initial sign when parameters change. Widths, heights and radii must remain
positive. Runtime feature failures propagate to the caller.
"""

import adsk.core
import adsk.fusion


_ZERO_CM = 1e-9


def _value(expression):
    """Create an expression-backed input; never silently interpret a bare number."""
    if not isinstance(expression, str) or not expression.strip():
        raise TypeError("Lengths must be non-empty Fusion expression strings.")
    return adsk.core.ValueInput.createByString(expression)


def evaluate_cm(component, expression):
    """Evaluate a length expression in internal centimetres, using mm by default."""
    _value(expression)
    units = component.parentDesign.unitsManager
    if not units.isValidExpression(expression, "mm"):
        raise ValueError("Invalid Fusion length expression: " + expression)
    return units.evaluateExpression(expression, "mm")


def _point(x, y, z=0):
    return adsk.core.Point3D.create(x, y, z)


def new_component(root, name):
    """Create and return a named child Component at an identity occurrence."""
    occurrence = root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    occurrence.component.name = name
    return occurrence.component


def offset_plane(component, z_expr, name=None):
    """Create an expression-driven offset from component XY, including zero."""
    evaluate_cm(component, z_expr)
    plane_input = component.constructionPlanes.createInput()
    if not plane_input.setByOffset(component.xYConstructionPlane, _value(z_expr)):
        raise RuntimeError("Could not define XY offset plane: " + z_expr)
    plane = component.constructionPlanes.add(plane_input)
    if name:
        plane.name = name
    plane.isLightBulbOn = False
    return plane


def _xy_sketch(component, name, z_expr):
    plane = offset_plane(component, z_expr, name + " / plane")
    sketch = component.sketches.add(plane)
    sketch.name = name
    return sketch


def _dimension(sketch, first, second, orientation, expression, text_x, text_y):
    dimension = sketch.sketchDimensions.addDistanceDimension(
        first, second, orientation, _point(text_x, text_y), True
    )
    if dimension is None:
        raise RuntimeError("Could not add sketch dimension: " + expression)
    dimension.parameter.expression = expression
    return dimension


def _positioned_point(component, sketch, x_expr, y_expr):
    """Return a fully constrained point, sharing sketch origin when X=Y=0."""
    x = evaluate_cm(component, x_expr)
    y = evaluate_cm(component, y_expr)
    x_zero, y_zero = abs(x) < _ZERO_CM, abs(y) < _ZERO_CM
    if x_zero and y_zero:
        return sketch.originPoint
    point = sketch.sketchPoints.add(_point(x, y))
    origin = sketch.originPoint
    constraints = sketch.geometricConstraints
    orientations = adsk.fusion.DimensionOrientations
    if x_zero:
        constraints.addVerticalPoints(origin, point)
    else:
        _dimension(
            sketch, origin, point,
            orientations.HorizontalDimensionOrientation,
            x_expr if x > 0 else "-(" + x_expr + ")",
            x / 2, y - 0.5,
        )
    if y_zero:
        constraints.addHorizontalPoints(origin, point)
    else:
        _dimension(
            sketch, origin, point,
            orientations.VerticalDimensionOrientation,
            y_expr if y > 0 else "-(" + y_expr + ")",
            x - 0.5, y / 2,
        )
    return point


def rectangle_xy(component, name, x_expr, y_expr, width_expr, height_expr,
                 z_expr="0 mm"):
    """Create a fully constrained, single-profile XY rectangle Sketch.

    X and Y specify the lower-left corner; positive width and height extend in
    positive sketch X/Y. The corner is constrained before adding the rectangle,
    and the rectangle shares that existing point to avoid duplicate anchors.
    """
    sketch = _xy_sketch(component, name, z_expr)
    return _rectangle_in_sketch(
        component, sketch, x_expr, y_expr, width_expr, height_expr
    )


def _rectangle_in_sketch(component, sketch, x_expr, y_expr, width_expr, height_expr):
    """Constrain a rectangle using expressions in the sketch's own coordinates."""
    width = evaluate_cm(component, width_expr)
    height = evaluate_cm(component, height_expr)
    if width <= _ZERO_CM or height <= _ZERO_CM:
        raise ValueError("Rectangle width and height must be positive.")
    start = _positioned_point(component, sketch, x_expr, y_expr)
    x, y = start.geometry.x, start.geometry.y
    # Construct the loop with shared SketchPoints explicitly. Fusion's rectangle
    # convenience method does not guarantee a fully constrained rectangle;
    # individual calls also make the intended corner sharing unambiguous.
    line_collection = sketch.sketchCurves.sketchLines
    bottom = line_collection.addByTwoPoints(start, _point(x + width, y))
    right = line_collection.addByTwoPoints(
        bottom.endSketchPoint, _point(x + width, y + height)
    )
    top = line_collection.addByTwoPoints(
        right.endSketchPoint, _point(x, y + height)
    )
    left = line_collection.addByTwoPoints(top.endSketchPoint, start)
    lines = (bottom, right, top, left)
    constraints = sketch.geometricConstraints
    for line, constraint_type, add_constraint in (
        (bottom, adsk.fusion.HorizontalConstraint, constraints.addHorizontal),
        (right, adsk.fusion.VerticalConstraint, constraints.addVertical),
        (top, adsk.fusion.HorizontalConstraint, constraints.addHorizontal),
        (left, adsk.fusion.VerticalConstraint, constraints.addVertical),
    ):
        if not any(constraint_type.cast(existing)
                   for existing in line.geometricConstraints):
            add_constraint(line)
    horizontal = vertical = None
    for line in lines:
        a, b = line.startSketchPoint.geometry, line.endSketchPoint.geometry
        if abs(a.y - b.y) < _ZERO_CM and horizontal is None:
            horizontal = line
        if abs(a.x - b.x) < _ZERO_CM and vertical is None:
            vertical = line
    if horizontal is None or vertical is None:
        raise RuntimeError("Rectangle did not contain horizontal/vertical edges.")
    orientations = adsk.fusion.DimensionOrientations
    _dimension(
        sketch, horizontal.startSketchPoint, horizontal.endSketchPoint,
        orientations.HorizontalDimensionOrientation, width_expr,
        x + width / 2, y - 0.5,
    )
    _dimension(
        sketch, vertical.startSketchPoint, vertical.endSketchPoint,
        orientations.VerticalDimensionOrientation, height_expr,
        x + width + 0.5, y + height / 2,
    )
    if not sketch.isFullyConstrained:
        raise RuntimeError("Rectangle sketch remains under-constrained: " + sketch.name)
    return sketch


def circle_xy(component, name, x_expr, y_expr, radius_expr, z_expr="0 mm"):
    """Create a fully constrained single-profile XY circle Sketch."""
    sketch = _xy_sketch(component, name, z_expr)
    return _circle_in_sketch(component, sketch, x_expr, y_expr, radius_expr)


def _circle_in_sketch(component, sketch, x_expr, y_expr, radius_expr):
    """Constrain a circle using expressions in the sketch's own coordinates."""
    radius = evaluate_cm(component, radius_expr)
    if radius <= _ZERO_CM:
        raise ValueError("Circle radius must be positive.")
    center = _positioned_point(component, sketch, x_expr, y_expr)
    circle = sketch.sketchCurves.sketchCircles.addByCenterRadius(center, radius)
    dimension = sketch.sketchDimensions.addRadialDimension(
        circle,
        _point(center.geometry.x + radius + 0.5, center.geometry.y + radius),
        True,
    )
    if dimension is None:
        raise RuntimeError("Could not add circle radius dimension: " + sketch.name)
    dimension.parameter.expression = radius_expr
    if not sketch.isFullyConstrained:
        raise RuntimeError("Circle sketch remains under-constrained: " + sketch.name)
    return sketch


def _axis_sketch(component, name, normal_axis, offset_expr):
    """Return an offset sketch and local-axis mapping for identity components.

    Each mapping item is (model axis name, sign), in local X then local Y order.
    Only orthogonal origin planes are supported. The model/assembly coordinate
    conversion assumes the identity occurrences created by new_component.
    """
    base = {
        "x": component.yZConstructionPlane,
        "y": component.xZConstructionPlane,
        "z": component.xYConstructionPlane,
    }[normal_axis]
    normal_value = getattr(base.geometry.normal, normal_axis)
    if abs(abs(normal_value) - 1) > 1e-7:
        raise ValueError("Construction plane is not aligned with requested axis.")
    plane_input = component.constructionPlanes.createInput()
    signed_offset = offset_expr if normal_value > 0 else "-(" + offset_expr + ")"
    if not plane_input.setByOffset(base, _value(signed_offset)):
        raise RuntimeError("Could not define axis offset plane: " + name)
    plane = component.constructionPlanes.add(plane_input)
    plane.name = name + " / plane"
    plane.isLightBulbOn = False
    sketch = component.sketches.add(plane)
    sketch.name = name
    origin_coordinates = {"x": 0.0, "y": 0.0, "z": 0.0}
    origin_coordinates[normal_axis] = evaluate_cm(component, offset_expr)
    origin = sketch.modelToSketchSpace(_point(**origin_coordinates))
    if abs(origin.x) > 1e-7 or abs(origin.y) > 1e-7:
        raise ValueError("Axis helpers require components at identity transforms.")
    mapping = [None, None]
    for axis in "xyz":
        if axis == normal_axis:
            continue
        probe_coordinates = dict(origin_coordinates)
        probe_coordinates[axis] = 1.0
        probe = sketch.modelToSketchSpace(_point(**probe_coordinates))
        dx, dy = probe.x - origin.x, probe.y - origin.y
        if abs(abs(dx) - 1) < 1e-7 and abs(dy) < 1e-7:
            mapping[0] = (axis, 1 if dx > 0 else -1)
        elif abs(abs(dy) - 1) < 1e-7 and abs(dx) < 1e-7:
            mapping[1] = (axis, 1 if dy > 0 else -1)
        else:
            raise ValueError("Unexpected sketch orientation for " + name)
    if None in mapping:
        raise RuntimeError("Incomplete model-to-sketch mapping: " + name)
    return sketch, mapping


def _axis_rectangle(component, name, normal_axis, offset_expr, starts, sizes):
    sketch, mapping = _axis_sketch(component, name, normal_axis, offset_expr)
    local_starts, local_sizes = [], []
    for axis, sign in mapping:
        start, size = starts[axis], sizes[axis]
        # A reversed local axis starts at the opposite model-space corner.
        local_starts.append(start if sign > 0 else "-((" + start + ")+(" + size + "))")
        local_sizes.append(size)
    return _rectangle_in_sketch(component, sketch, *local_starts, *local_sizes)


def _axis_circle(component, name, normal_axis, offset_expr, centers, radius_expr):
    sketch, mapping = _axis_sketch(component, name, normal_axis, offset_expr)
    local = [centers[axis] if sign > 0 else "-(" + centers[axis] + ")"
             for axis, sign in mapping]
    return _circle_in_sketch(component, sketch, *local, radius_expr)


def rectangle_yz(component, name, y_expr, z_expr, height_y_expr, depth_z_expr,
                 x_expr="0 mm"):
    """Rectangle at model X, extending from Y/Z in positive model Y and Z."""
    return _axis_rectangle(component, name, "x", x_expr,
                           {"y": y_expr, "z": z_expr},
                           {"y": height_y_expr, "z": depth_z_expr})


def circle_yz(component, name, y_expr, z_expr, radius_expr, x_expr="0 mm"):
    """Circle at model X with model Y/Z center; use extrude_axis(..., axis='x')."""
    return _axis_circle(component, name, "x", x_expr,
                        {"y": y_expr, "z": z_expr}, radius_expr)


def rectangle_xz(component, name, x_expr, z_expr, width_x_expr, depth_z_expr,
                 y_expr="0 mm"):
    """Rectangle at model Y, extending from X/Z in positive model X and Z."""
    return _axis_rectangle(component, name, "y", y_expr,
                           {"x": x_expr, "z": z_expr},
                           {"x": width_x_expr, "z": depth_z_expr})


def circle_xz(component, name, x_expr, z_expr, radius_expr, y_expr="0 mm"):
    """Circle at model Y with model X/Z center; use extrude_axis(..., axis='y')."""
    return _axis_circle(component, name, "y", y_expr,
                        {"x": x_expr, "z": z_expr}, radius_expr)


def extrude_axis(component, sketch, distance_expr, name, axis,
                 operation="new", participants=None):
    """Extrude positive distance along positive model X/Y/Z, regardless of plane.

    This wrapper inspects the sketch normal, so XZ/YZ origin-plane orientation
    need not be assumed. Negative distance reverses the requested model axis.
    The sketch must be perpendicular to that axis and have one profile.
    """
    if axis not in ("x", "y", "z"):
        raise ValueError("Extrusion axis must be x, y or z.")
    origin = sketch.sketchToModelSpace(_point(0, 0, 0))
    normal_probe = sketch.sketchToModelSpace(_point(0, 0, 1))
    normal_component = getattr(normal_probe, axis) - getattr(origin, axis)
    if abs(abs(normal_component) - 1) > 1e-7:
        raise ValueError("Sketch is not perpendicular to requested extrusion axis.")
    normal_distance = (distance_expr if normal_component > 0
                       else "-(" + distance_expr + ")")
    return extrude(component, sketch, normal_distance, name, operation, participants)


def extrude(component, sketch_or_profile, distance_expr, name,
            operation="new", participants=None):
    """Extrude an expression distance; return the named ExtrudeFeature.

    ``operation`` is ``new``, ``join`` or ``cut``. A Sketch must have exactly one
    profile; pass an explicit Profile/ObjectCollection for more complex sketches.
    For Cut, participants may explicitly restrict affected bodies. Fusion only
    supports participantBodies for Cut/Intersect, so participants are rejected
    for New/Join. Isolate joins in the intended component. Signed distances select
    the corresponding sketch-normal direction; they must not cross zero later.
    """
    operations = {
        "new": adsk.fusion.FeatureOperations.NewBodyFeatureOperation,
        "join": adsk.fusion.FeatureOperations.JoinFeatureOperation,
        "cut": adsk.fusion.FeatureOperations.CutFeatureOperation,
    }
    if operation not in operations:
        raise ValueError("Unknown extrusion operation: " + str(operation))
    if participants is not None and operation != "cut":
        raise ValueError("Fusion participantBodies is supported only for Cut here.")
    if participants is not None and not participants:
        raise ValueError("An explicit participant body list cannot be empty.")
    distance = evaluate_cm(component, distance_expr)
    if abs(distance) < _ZERO_CM:
        raise ValueError("Extrusion distance cannot be zero.")
    sketch = adsk.fusion.Sketch.cast(sketch_or_profile)
    if sketch:
        if sketch.profiles.count != 1:
            raise ValueError("Pass an explicit profile for a multi-profile sketch.")
        profile = sketch.profiles.item(0)
    else:
        profile = sketch_or_profile
    extrudes = component.features.extrudeFeatures
    feature_input = extrudes.createInput(profile, operations[operation])
    extent = adsk.fusion.DistanceExtentDefinition.create(_value(
        distance_expr if distance > 0 else "-(" + distance_expr + ")"
    ))
    direction = (
        adsk.fusion.ExtentDirections.PositiveExtentDirection if distance > 0
        else adsk.fusion.ExtentDirections.NegativeExtentDirection
    )
    if not feature_input.setOneSideExtent(extent, direction):
        raise RuntimeError("Could not define extrusion extent: " + name)
    if participants is not None:
        feature_input.participantBodies = list(participants)
    feature = extrudes.add(feature_input)
    feature.name = name
    if sketch:
        sketch.isLightBulbOn = False
    return feature
