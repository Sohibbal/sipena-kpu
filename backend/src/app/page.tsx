export const dynamic = 'force-dynamic';

import prisma from "@/lib/prisma";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, FileText, Activity } from "lucide-react";

export default async function DashboardPage() {
  const totalPendata = await prisma.pendata.count();
  const totalPemilih = await prisma.pemilih.count();
  
  // Get top pendata (who inputted the most data)
  const topPendataList = await prisma.pemilih.groupBy({
    by: ['id_pendata'],
    _count: {
      id_pendata: true,
    },
    orderBy: {
      _count: {
        id_pendata: 'desc',
      },
    },
    take: 5,
  });

  // Fetch names for the top pendata
  const topPendataWithNames = await Promise.all(
    topPendataList.map(async (p) => {
      const pendata = await prisma.pendata.findUnique({ where: { id: p.id_pendata } });
      return {
        nama_lengkap: pendata?.nama_lengkap || "Unknown",
        count: p._count.id_pendata,
      };
    })
  );

  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold tracking-tight">Dashboard KPU</h1>
      </div>

      <div className="grid gap-4 md:grid-cols-2 md:gap-8 lg:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2 space-y-0">
            <CardTitle className="text-sm font-medium">Total Petugas</CardTitle>
            <Users className="w-4 h-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{totalPendata}</div>
            <p className="text-xs text-muted-foreground">Petugas lapangan terdaftar</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2 space-y-0">
            <CardTitle className="text-sm font-medium">Total Pemilih</CardTitle>
            <FileText className="w-4 h-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{totalPemilih}</div>
            <p className="text-xs text-muted-foreground">Data tersinkronisasi dari lapangan</p>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <Card className="col-span-4">
          <CardHeader>
            <CardTitle>Insight: Top Petugas Pendata</CardTitle>
            <CardDescription>
              Menampilkan petugas lapangan yang paling banyak menginput data.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-8 mt-4">
              {topPendataWithNames.length === 0 ? (
                <div className="text-sm text-muted-foreground">Belum ada insight data.</div>
              ) : (
                topPendataWithNames.map((p, i) => (
                  <div className="flex items-center" key={i}>
                    <div className="space-y-1">
                      <p className="text-sm font-medium leading-none">{p.nama_lengkap}</p>
                    </div>
                    <div className="ml-auto font-medium">+{p.count} Data</div>
                  </div>
                ))
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
