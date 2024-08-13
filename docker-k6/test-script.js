import http from 'k6/http';
import { sleep, check } from 'k6';

/*
  Tips:
    * VUs are essentially parallel while(true) loops
    * VU code does not load files from your local filesystem. VU code does not import any other modules. Instead of VU code, init code does these jobs.
  Resources: 
  - https://k6.io/docs/get-started/running-k6/
  - https://k6.io/docs/using-k6/test-lifecycle/

*/

export let options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  let res = http.get('https://test.k6.io');
  check(res, {
    'status was 200': (r) => r.status == 200,
  });
  sleep(1);
}