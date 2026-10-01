-- D1 schema for fieldapp-team-view-db — the copy-on-approve read-only mirror.
-- Contains ONLY approved, plot-averaged moisture values (and, as of the
-- second table, per-point moisture averages) for active plots. No raw probe
-- replicate readings, EC/density/lab results, GPS, photos, or other menus
-- ever get written here — see functions/api/moisture/approve.js.
--
-- Run once after creating the D1 database:
--   wrangler d1 execute fieldapp-team-view-db --remote --file=schema-team-view.sql
-- Re-run safely any time after — both statements are idempotent (IF NOT EXISTS).

CREATE TABLE IF NOT EXISTS approved_moisture (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plot_code TEXT NOT NULL,
  province TEXT NOT NULL,
  crop_type TEXT NOT NULL,
  round INTEGER NOT NULL,
  round_label TEXT,
  measured_date TEXT NOT NULL,
  dap INTEGER,
  moist_0_10cm_avg REAL,
  moist_10_20cm_avg REAL,
  approved_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(plot_code, round)
);

-- One row per sampling point per approved round: just that point's moisture
-- average at each depth (already averaged from the probe's 3 replicate
-- readings) — never the raw replicate values themselves.
CREATE TABLE IF NOT EXISTS approved_moisture_points (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plot_code TEXT NOT NULL,
  round INTEGER NOT NULL,
  point_index INTEGER NOT NULL,
  coord TEXT,
  moist_0_10cm REAL,
  moist_10_20cm REAL,
  UNIQUE(plot_code, round, point_index)
);
