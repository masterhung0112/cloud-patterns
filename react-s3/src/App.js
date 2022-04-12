import logo from "./logo.svg";
import "./App.css";
import { useFetch } from "react-async";

// const APIEndPoint = 'to be replaced with your api endpoint here'
const APIEndPoint = 'https://4gxqbwo4b0.execute-api.us-west-2.amazonaws.com/v1/hello'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <APIResult />
        <img src={logo} className="App-MainLogo" alt="logo" />
      </header>
      <p>
        This react-based application is hosted in an S3 bucket exposed through a
        CloudFront distribution
      </p>
    </div>
  );
}

const APIResult = () => {
  const { data, error } = useFetch(APIEndPoint, {
    headers: { accept: "application/json" },
  });
  if (error) return <p>{error.message}</p>;
  if (data) return <p>{data.message}</p>;
  return null;
};

export default App;
