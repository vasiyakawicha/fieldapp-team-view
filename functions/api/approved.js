// GET /api/approved -> { rows: [...] }
// Read-only. Returns every row of approved_moisture, each with its matching
// per-point moisture averages nested under `points`. This whole site has no
// write endpoints, so there is no path by which anything other than the main
// site's approve step can ever reach this database.
export async function onRequestGet({ env }) {
  const [moistureResult, pointsResult] = await Promise.all([
    env.TEAM_DB.prepare(
      "SELECT plot_code, province, crop_type, round, round_label, measured_date, dap, moist_0_10cm_avg, moist_10_20cm_avg, approved_at FROM approved_moisture ORDER BY plot_code, round"
    ).all(),
    env.TEAM_DB.prepare(
      "SELECT plot_code, round, point_index, coord, moist_0_10cm, moist_10_20cm FROM approved_moisture_points ORDER BY plot_code, round, point_index"
    ).all(),
  ]);

  const pointsByKey = {};
  for (const p of pointsResult.results) {
    const key = p.plot_code + "::" + p.round;
    if (!pointsByKey[key]) pointsByKey[key] = [];
    pointsByKey[key].push({
      pointIndex: p.point_index,
      coord: p.coord,
      moist0_10: p.moist_0_10cm,
      moist10_20: p.moist_10_20cm,
    });
  }

  const rows = moistureResult.results.map((r) => ({
    ...r,
    points: pointsByKey[r.plot_code + "::" + r.round] || [],
  }));

  return new Response(JSON.stringify({ rows }), {
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}
