process.env['AWS_REGION'] = process.env['AWS_DEFAULT_REGION'];

import { handler } from './lambda';

(async () => {
    await handler({});
})();