# Independent review of the combined SYS route

The frozen candidate `de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db` adds the C105–SYS connection and the associated CE, SET and CHG signal detours. This is a scoped integration checkpoint, **not an order release**. The candidate has six remaining unconnected items and two unresolved R101 schematic/PCB metadata differences.

[review.json](review.json) compares independently generated native trace/barrel witnesses against source `f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432`. All 25 previously connected paths retain exactly the same copper-item witnesses. Four additional requested paths now connect: U101 pins 15/16 to C105, and C105 to U201 pins 10/11. All 29 requested power and voltage-monitor pairs therefore have explicit paths without inferring conduction through zones, component internals or shared pin labels.

The change contains eleven new 0.40 mm In2 SYS segments and no new power vias. [current-paths/inventory.json](current-paths/inventory.json) and its CSVs retain the individual conductor and barrel details, full-item resistance estimates and labelled sensitivity assumptions. These are not equivalent-resistance solutions or current/thermal ratings. They do not replace the all-net native DRC, physical load tests or final manufacturing review.

The RAW input uses a short, existing 0.15 mm package escape into U115's central IN land. Its two nominal segments total 1.80355 mm, but only 0.40355 mm of their centreline lies outside the IN land and adjacent wider B copper. This is an actual load connection, not a voltage-sense branch. The root reviewer inspected [the actual copper overlay](raw-input-escape.png) on 2026-09-08. Its geometry remains an explicit item in the final power-path review; no temperature or current limit has been established by that image.

The proposed later C116 move is **not** in this candidate and conflicts with its CHG via at (15.95, 88.35). That combined change must be corrected and checked afresh before adoption. The frozen evidence here remains unchanged.
