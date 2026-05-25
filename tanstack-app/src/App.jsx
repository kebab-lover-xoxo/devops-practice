import { useQuery } from '@tanstack/react-query';

const fetchMessage = async () => {
  const res = await fetch('https://jsonplaceholder.typicode.com/todos/1');
  return res.json();
};

export default function App() {
  const { data, isLoading, error } = useQuery(['todo'], fetchMessage);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading data.</div>;

  return (
    <main style={{ fontFamily: 'system-ui, sans-serif', padding: '2rem' }}>
      <h1>TanStack React Query App</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </main>
  );
}
