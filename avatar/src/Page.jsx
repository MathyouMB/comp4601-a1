import {
  useParams
} from "react-router-dom";
import { useEffect, useState} from 'react';

const Page = () => {
  let { id } = useParams();
  const [data, setData] = useState({});

  const requestData = async () => {
      const url = `http://localhost:4001/pages/${id}`;
      fetch(url)
          .then(res => res.json())
          .then(data => setData(data.data))
  }

  useEffect(() => {
      requestData();
      console.log(data)
  }, []);

return (
<div>
    {(data != null || data !== {}) &&
      <>
      <h1>{data.title}</h1>
      <p>{data.url}</p>
      <p>{data.html}</p>
      <p>{data.page_rank}</p>
      {(data.incoming !== undefined) &&
          <>
          <h3>incoming</h3>
          <ul>{data.incoming.map(url => <li>{url}</li>)}</ul>
          <h3>outgoing</h3>
          <ul>{data.outgoing.map(url => <li>{url}</li>)}</ul>
          <h3>word frequency</h3>
          <ul>{Object.entries(data.word_frequency).map(([word, count])=> <li>{word}: {count}</li>)}</ul>
          </>
      }
      </>
  }

</div>
);
};

export default Page;
