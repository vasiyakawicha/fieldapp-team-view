-- D1 schema for fieldapp-team-view-db — the copy-on-approve read-only mirror.
-- Contains ONLY approved, plot-averaged moisture values for active plots.
-- No raw per-point data, EC/density/lab results, GPS, photos, or other menus
-- ever get written here — see functions/api/moisture/approve.js.
--
-- Run once after creating the D1 database:
--   wrangler d1 execute fieldapp-team-view-db --remote --file=schema-team-view.sql

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
