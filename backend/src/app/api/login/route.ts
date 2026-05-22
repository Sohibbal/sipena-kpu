export const dynamic = 'force-dynamic';

import { NextResponse } from "next/server";
import prisma from "@/lib/prisma";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { username, password } = body;

    if (!username || !password) {
      return NextResponse.json({ success: false, message: "Username dan password dibutuhkan" }, { status: 400 });
    }

    const pendata = await prisma.pendata.findUnique({
      where: { username },
    });

    // In production, use bcrypt.compare here
    if (!pendata || pendata.password !== password) {
      return NextResponse.json({ success: false, message: "Username atau password salah" }, { status: 401 });
    }

    return NextResponse.json({
      success: true,
      message: "Login berhasil",
      data: {
        id: pendata.id,
        username: pendata.username,
        nama_lengkap: pendata.nama_lengkap,
        wilayah_tugas: pendata.wilayah_tugas,
      }
    });

  } catch (error: any) {
    return NextResponse.json({ success: false, message: "Terjadi kesalahan server", error: error.message }, { status: 500 });
  }
}
