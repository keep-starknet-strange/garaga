'use client';

import { useState, useEffect } from 'react';
import * as garaga from 'garaga';
import { proofBn254, vkBn254 } from './examples';

export default function Home() {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(async () => {
    try {
      await garaga.init();
      const result = garaga.msmCalldataBuilder([[1n, 2n]], [10n], garaga.CurveId.BN254);
      const json = JSON.stringify(result, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
      const message = 'Output of msm_calldata_builder: ' + json;
      let tmpData = message;

      const groth16Calldata = garaga.getGroth16CallData(proofBn254, vkBn254,garaga.CurveId.BN254);

      const jsonCalldata = JSON.stringify(groth16Calldata, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);

      const messageCalldata = 'Output of get_groth16_calldata: ' + jsonCalldata;

      setData(tmpData + "\n" + messageCalldata);

    } catch (e) {
      setError(String(e));
    } finally {
      setLoading(false);
    }
  }, []);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <pre>
      {data}
    </pre>
  );
}
