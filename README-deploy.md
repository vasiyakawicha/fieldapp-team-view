# เว็บทีม (read-only) — สมุดบันทึกแปลงทดลอง

เว็บนี้แยกต่างหากจากเว็บหลัก (`cf-deploy/`) โดยสมบูรณ์ — อ่านข้อมูลอย่างเดียวจาก D1
`fieldapp-team-view-db` ซึ่งมีแค่ค่าเฉลี่ยความชื้นที่อนุมัติแล้วเท่านั้น (เขียนได้จากเว็บหลัก
ผ่าน `/api/moisture/approve` เพียงจุดเดียว) ไม่มีช่องทางแก้ไขข้อมูลจากเว็บนี้เลย

- Deploy แล้วที่ https://fieldapp-team-view.pages.dev (ผ่าน `wrangler pages deploy` แบบ
  direct-upload ตอนสร้างครั้งแรก — ยังไม่ได้ต่อ git auto-deploy)
- D1 binding `TEAM_DB` ผูกกับ `fieldapp-team-view-db` ไว้แล้วทั้ง production/preview
  ผ่าน Cloudflare API

## ต่อ Git ให้ auto-deploy เหมือนเว็บหลัก

1. สร้าง GitHub repo เปล่าใหม่ (เช่น `fieldapp-team-view`) ใต้บัญชี GitHub เดียวกับเว็บหลัก
2. รันในโฟลเดอร์นี้:
   ```bash
   git init
   git add .
   git commit -m "Initial team view site"
   git remote add origin https://github.com/<your-account>/fieldapp-team-view.git
   git push -u origin main
   ```
3. ไป **github.com/settings/installations** → หา Cloudflare Pages app → กด "Configure" →
   เพิ่ม repo `fieldapp-team-view` เข้าไปในสิทธิ์ที่ Cloudflare เข้าถึงได้
   (ถ้า installation ตั้งเป็น "All repositories" อยู่แล้วข้ามขั้นตอนนี้ได้)
4. ไป Cloudflare dashboard → **Workers & Pages → fieldapp-team-view → Settings →
   Builds & deployments → Connect to Git** เลือก repo ที่เพิ่งสร้าง (branch `main`,
   build output directory = `public`, ไม่ต้องตั้ง build command)
5. เช็คว่า D1 binding `TEAM_DB` ยังอยู่ครบหลัง connect (Settings → Functions →
   D1 database bindings) เผื่อ Cloudflare รีเซ็ตตอนเปลี่ยนมาเป็น git-connected
