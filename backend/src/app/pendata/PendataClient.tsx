"use client";

import { useState } from "react";
import { addPendata, deletePendata } from "../actions/pendata";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";

export default function PendataClient({ pendataList }: { pendataList: any[] }) {
  const [open, setOpen] = useState(false);

  async function handleAdd(formData: FormData) {
    const res = await addPendata(formData);
    if (res.success) {
      setOpen(false);
    } else {
      alert("Error: " + res.error);
    }
  }

  async function handleDelete(id: number) {
    if (confirm("Apakah Anda yakin ingin menghapus pendata ini?")) {
      await deletePendata(id);
    }
  }

  return (
    <>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold tracking-tight">Manajemen Pendata</h1>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger render={<Button>Tambah Pendata</Button>} />
          <DialogContent className="sm:max-w-[425px]">
            <form action={handleAdd}>
              <DialogHeader>
                <DialogTitle>Tambah Pendata</DialogTitle>
                <DialogDescription>
                  Buat akun untuk petugas lapangan yang akan menggunakan aplikasi mobile.
                </DialogDescription>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label htmlFor="username">Username</Label>
                  <Input id="username" name="username" required />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="password">Password</Label>
                  <Input id="password" name="password" type="password" required />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="nama_lengkap">Nama Lengkap</Label>
                  <Input id="nama_lengkap" name="nama_lengkap" required />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="wilayah_tugas">Wilayah Tugas</Label>
                  <Input id="wilayah_tugas" name="wilayah_tugas" required />
                </div>
              </div>
              <DialogFooter>
                <Button type="submit">Simpan</Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="rounded-md border bg-card text-card-foreground shadow-sm">
        <div className="p-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nama Lengkap</TableHead>
                <TableHead>Username</TableHead>
                <TableHead>Wilayah Tugas</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {pendataList.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center">Belum ada data petugas.</TableCell>
                </TableRow>
              ) : (
                pendataList.map((p) => (
                  <TableRow key={p.id}>
                    <TableCell className="font-medium">{p.nama_lengkap}</TableCell>
                    <TableCell>{p.username}</TableCell>
                    <TableCell>{p.wilayah_tugas}</TableCell>
                    <TableCell className="text-right">
                      <Button variant="destructive" size="sm" onClick={() => handleDelete(p.id)}>
                        Hapus
                      </Button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      </div>
    </>
  );
}
