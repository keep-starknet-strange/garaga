'use client';

import { useState, useEffect } from 'react';
import * as garaga_rs from 'garaga_rs';

export default function Home() {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(async () => {
    try {
      await garaga_rs.init();
      const result = garaga_rs.msm_calldata_builder([1, 2], [10], 0, true, true, false, false);
      const json = JSON.stringify(result, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
      const message = 'Output of msm_calldata_builder: ' + json;
      setData(message);
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
