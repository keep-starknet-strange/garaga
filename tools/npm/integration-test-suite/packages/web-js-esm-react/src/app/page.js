'use client';

import { useState, useEffect } from 'react';
import * as garaga_rs from 'garaga_rs';

function prepareForJson(key, value) {
  return typeof value === 'bigint' ? value.toString() : value;
}

export default function Home() {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(async () => {
    try {
      await garaga_rs.init();
      const result = garaga_rs.msm_calldata_builder([1, 2], [10], 0);
      setData(JSON.stringify(result, prepareForJson, 2));
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
    <div>
      <main>
        <pre>
          Output of msm_calldata_builder:
          {data}
        </pre>
      </main>
    </div>
  );
}
