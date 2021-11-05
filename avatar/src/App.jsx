import "./App.css";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Page from './Page'
import Search from './Search'

const App = () => {
  return (
  <BrowserRouter>
    <Routes>
      <Route path="/fruits" element={<Search endpoint={"fruits"}/>} />
      <Route path="/personal" element={<Search endpoint={"personal"}/>} />
      <Route path="/page/:id" element={<Page/>} />
      <Route path="/" element={<>Welcome</>} />
    </Routes>
  </BrowserRouter>
  );
};

export default App;
