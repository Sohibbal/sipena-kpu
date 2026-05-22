import Link from "next/link";
import { Home, Users, FileText } from "lucide-react";

export function Sidebar() {
  return (
    <div className="flex h-full w-64 flex-col border-r bg-muted/20">
      <div className="flex h-14 items-center border-b px-4 lg:h-[60px] lg:px-6">
        <Link href="/" className="flex items-center gap-2 font-semibold">
          <span className="text-red-700 text-xl font-bold">KPU</span>
          <span>Dashboard</span>
        </Link>
      </div>
      <div className="flex-1 overflow-auto py-2">
        <nav className="grid items-start px-2 text-sm font-medium lg:px-4 gap-2">
          <Link
            href="/"
            className="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-muted"
          >
            <Home className="h-4 w-4" />
            Beranda
          </Link>
          <Link
            href="/pendata"
            className="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-muted"
          >
            <Users className="h-4 w-4" />
            Manajemen Pendata
          </Link>
          <Link
            href="/pemilih"
            className="flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-muted"
          >
            <FileText className="h-4 w-4" />
            Data Pemilih
          </Link>
        </nav>
      </div>
    </div>
  );
}
