"use client";

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function PemilihClient({ pemilihList }: { pemilihList: any[] }) {
  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold tracking-tight">Data Pemilih</h1>
      </div>
      
      <Card>
        <CardHeader>
          <CardTitle>Daftar Pemilih Terdaftar</CardTitle>
          <CardDescription>
            Seluruh data pemilih yang telah disinkronisasikan oleh petugas lapangan.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>NIK</TableHead>
                  <TableHead>Nama Lengkap</TableHead>
                  <TableHead>Gender</TableHead>
                  <TableHead>Alamat</TableHead>
                  <TableHead>Petugas (Pendata)</TableHead>
                  <TableHead>Waktu Sync</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {pemilihList.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center">Belum ada data pemilih.</TableCell>
                  </TableRow>
                ) : (
                  pemilihList.map((p) => (
                    <TableRow key={p.id}>
                      <TableCell className="font-medium">{p.nik}</TableCell>
                      <TableCell>{p.nama_lengkap}</TableCell>
                      <TableCell>
                        <Badge variant="outline">{p.jenis_kelamin}</Badge>
                      </TableCell>
                      <TableCell className="max-w-xs truncate" title={p.alamat}>{p.alamat}</TableCell>
                      <TableCell>{p.pendata?.nama_lengkap || 'Unknown'}</TableCell>
                      <TableCell>{new Date(p.created_at).toLocaleDateString('id-ID')}</TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
