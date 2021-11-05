import React, { useState } from 'react';
import {
    Link
  } from "react-router-dom";


const Search = (params) => {
    const [q, setQ] = useState("");
    const [limit, setLimit] = useState("");
    const [boost, setBoost] = useState(false);

    const [results, setResults] = useState([]);

    const updateQ = (e) => {
        setQ(e.target.value)
    }

    const updateLimit = (e) => {
        setLimit(e.target.value)
    }

    const updateBoost = (e) => {
        setBoost(e.target.checked)
    }

    const search = () => {
        const url = `http://localhost:4001/${params.endpoint}?q=${q}&limit=${limit}&boost=${boost}`;
        fetch(url)
            .then(res => res.json())
            .then(data => setResults(data.data))

    }
  return (
  <div>
      <div>
        <h1>{params.endpoint}</h1>
        <input type="text" placeholder="Search" value={q} onChange={updateQ}/>
        <input type="text" placeholder="limit" value={limit} onChange={updateLimit}/>
        Boosted: <input type="checkbox" value={boost} onChange={updateBoost}></input>
        <input type="button" value={"search"} onClick={search}/>
      </div>
      <div>
        <h2>Results</h2>
        <ul>
            {results.map(result => (
                <li key={result.id}>
                    <Link to={`/page/${result.id}`}>{result.url}</Link>
                </li>
            ))}
        </ul>
      </div>
  </div>
  );
};

export default Search;
