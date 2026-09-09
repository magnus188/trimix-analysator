# Additional high-voltage limiter screen

TPS2660 was checked as a possible way to remove the low-voltage limiter's transient exposure. It is not selected and no native design was changed by this screen. TI specifies a 0.1–2.23 A adjustment range, with 85/100/115 mA at the lowest 120 kΩ setting under the stated conditions. Its high-voltage rating is useful, but the specified maximum already exceeds a 100 mA default-port budget before other loads. Assuming an undocumented resistor setting would not establish a guaranteed lower ceiling. [TI TPS2660](https://www.ti.com/lit/gpn/tps2660)

The related TPS2662 lists a lower 25 mA adjustment endpoint but an 0.88 A maximum. It does not preserve the current design's qualified high-current target as a direct replacement. [TI TPS2662](https://www.ti.com/product/TPS2662)

This is a narrow alternative screen, not an exhaustive component survey. The selected TPS259470/TPS22950-Q1 design retains the explicit transient qualification hold in upstream-ovp-review.md. No typical-only calculation is promoted to a guaranteed protective limit.
