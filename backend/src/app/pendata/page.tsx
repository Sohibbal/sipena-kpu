export const dynamic = 'force-dynamic';

import { getPendataList } from "../actions/pendata";
import PendataClient from "./PendataClient";

export default async function PendataPage() {
  const res = await getPendataList();
  const pendataList = res.data ?? [];

  return (
    <div className="flex flex-col gap-4">
      <PendataClient pendataList={pendataList} />
    </div>
  );
}
