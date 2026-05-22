"use server";

import prisma from "@/lib/prisma";

export async function getPemilihList() {
  try {
    const pemilih = await prisma.pemilih.findMany({
      include: {
        pendata: true, // Include pendata information
      },
      orderBy: { created_at: "desc" },
    });
    return { success: true, data: pemilih };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
