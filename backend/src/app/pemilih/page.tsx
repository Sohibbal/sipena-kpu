export const dynamic = 'force-dynamic';

import { getPemilihList } from "../actions/pemilih";
import PemilihClient from "./PemilihClient";

export default async function PemilihPage() {
  const res = await getPemilihList();
  const pemilihList = res.data ?? [];

  return (
    <PemilihClient pemilihList={pemilihList} />
  );
}
