"use server";

import prisma from "@/lib/prisma";
import { revalidatePath } from "next/cache";

export async function getPendataList() {
  try {
    const pendata = await prisma.pendata.findMany({
      orderBy: { created_at: "desc" },
    });
    return { success: true, data: pendata };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function addPendata(formData: FormData) {
  try {
    const username = formData.get("username") as string;
    const password = formData.get("password") as string;
    const nama_lengkap = formData.get("nama_lengkap") as string;
    const wilayah_tugas = formData.get("wilayah_tugas") as string;

    await prisma.pendata.create({
      data: {
        username,
        password, // In a real app, hash this! (e.g. bcrypt)
        nama_lengkap,
        wilayah_tugas,
      },
    });

    revalidatePath("/pendata");
    return { success: true };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}

export async function deletePendata(id: number) {
  try {
    await prisma.pendata.delete({
      where: { id },
    });
    revalidatePath("/pendata");
    return { success: true };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
