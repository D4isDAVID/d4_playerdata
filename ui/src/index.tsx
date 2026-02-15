import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

import './index.css';

const rootElement = document.getElementById('root');

if (rootElement) {
    const root = createRoot(rootElement);

    root.render(
        <StrictMode>
            <p>Hello, world!</p>
        </StrictMode>,
    );
}
