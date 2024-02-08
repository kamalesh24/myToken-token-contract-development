import React, {useState} from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import {Principal} from '@dfinity/principal';
// import { AuthClient } from "@dfinity/auth-client";

function Transfer(props) {

  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [result, setText] = useState("");
  const [isHidden, setHidden] = useState(true);
  const [isDisabled, setDisable] = useState(false);
  
  async function handleClick() {
    setHidden(true);
    setDisable(true);
    const recipient = Principal.fromText(to);
    const amt = Number(amount);

    // const authClient = await AuthClient.create();
    // const identity = await authClient.getIdentity();
    // const authenticatedCanister = createActor(canisterId, {
    //   agentOptions: {
    //     identity,
    //   },
    // });

    let res = await token.transfer(recipient, amt);
    setText(res);
    setHidden(false);
    setDisable(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={to}
                onChange={(e) => setTo(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button 
          id="btn-transfer" 
          onClick={handleClick} 
          disabled={isDisabled}
          >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}>{result}.</p>
      </div>
    </div>
  );
}

export default Transfer;
