import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as dfc_idl, canisterId as dfc_id } from 'dfx-generated/dfc';

const agent = new HttpAgent();
const dfc = Actor.createActor(dfc_idl, { agent, canisterId: dfc_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await dfc.greet(name);

  document.getElementById("greeting").innerText = greeting;
});


    // "dfc_assets": {
    //   "dependencies": [
    //     "dfc"
    //   ],
    //   "frontend": {
    //     "entrypoint": "src/dfc_assets/src/index.html"
    //   },
    //   "source": [
    //     "src/dfc_assets/assets",
    //     "dist/dfc_assets/"
    //   ],
    //   "type": "assets"
    // }