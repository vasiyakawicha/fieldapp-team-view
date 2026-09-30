// GET /api/approved -> { rows: [...] }
// Read-only. Returns every row of the approved_moisture table — this whole
// site has no write endpoints, so there is no path by which anything other
// than the main site's approve step can ever reach this database.
export async function onRequestGet({ env }) {
  const { results } = await env.TEAM_DB.prepare(
    "SELECT plot_code, province, crop_type, round, round_label, measured_date, dap, moist_0_10cm_avg, moist_10_20cm_avg, approved_at FROM approved_moisture ORDER BY plot_code, round"
  ).all();
  return new Response(JSON.stringify({ rows: results }), {
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}
