export const dynamic = 'force-dynamic';

import { NextResponse } from "next/server";
import prisma from "@/lib/prisma";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    // Expecting payload: { id_pendata: number, data: [] }
    const { id_pendata, data } = body;

    if (!id_pendata || !data || !Array.isArray(data)) {
      return NextResponse.json({ success: false, message: "Payload tidak valid" }, { status: 400 });
    }

    const insertedData = [];

    // Process each record
    for (const item of data) {
      // Check if NIK already exists to prevent duplicates
      const existing = await prisma.pemilih.findUnique({
        where: { nik: item.nik },
      });

      if (!existing) {
        const result = await prisma.pemilih.create({
          data: {
            nik: item.nik,
            nama_lengkap: item.nama_lengkap,
            no_hp: item.no_hp,
            jenis_kelamin: item.jenis_kelamin,
            tanggal_pendataan: new Date(item.tanggal_pendataan),
            alamat: item.alamat,
            latitude: item.latitude ? parseFloat(item.latitude) : null,
            longitude: item.longitude ? parseFloat(item.longitude) : null,
            foto_url: item.foto_url || null, // Could be a base64 string or file path
            id_pendata: id_pendata,
          },
        });
        insertedData.push(result);
      }
    }

    return NextResponse.json({
      success: true,
      message: "Sinkronisasi berhasil",
      inserted_count: insertedData.length,
    });

  } catch (error: any) {
    return NextResponse.json({ success: false, message: "Terjadi kesalahan server", error: error.message }, { status: 500 });
  }
}
