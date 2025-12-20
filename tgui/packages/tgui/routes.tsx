/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useBackend } from './backend';
import { useDebug } from './debug';
import { LoadingScreen } from './interfaces/common/LoadingScreen';
import { Window } from './layouts';

const requireInterface = require.context('./interfaces');

const routingError =
  (type: 'notFound' | 'missingExport', name: string) => () => {
    return (
      <Window>
        <Window.Content scrollable>
          {type === 'notFound' && (
            <div>
              Interface <b>{name}</b> was not found.
            </div>
          )}
          {type === 'missingExport' && (
            <div>
              Interface <b>{name}</b> is missing an export.
            </div>
          )}
        </Window.Content>
      </Window>
    );
  };

// Displays an empty Window with scrollable content
function SuspendedWindow() {
  return (
    <Window>
      <Window.Content scrollable />
    </Window>
  );
}

// Displays a loading screen with a spinning icon
function RefreshingWindow() {
  return (
    <Window title="Loading">
      <Window.Content>
        <LoadingScreen />
      </Window.Content>
    </Window>
  );
}

const interfaceSubdirectories = [
  `.`,
  `./computers`,
  `./items`,
  `./machines`,
  `./modules`,
  `./ui`,
];

const interfacePaths = (name: string) => {
  let built: [string?] = [
    name,
  ];
  for (let i = 0; i < interfaceSubdirectories.length; i++) {
    let dir = interfaceSubdirectories[i];
    built.push(`${dir}/${name}.jsx`);
    built.push(`${dir}/${name}.tsx`);
    built.push(`${dir}/${name}/index.jsx`);
    built.push(`${dir}/${name}/index.tsx`);
  }
  return built;
};

// Get the component for the current route
export function getRoutedComponent() {
  const { suspended, config } = useBackend();
  const { kitchenSink = false } = useDebug();

  if (suspended) {
    return SuspendedWindow;
  }
  if (config?.refreshing) {
    return RefreshingWindow;
  }

  if (process.env.NODE_ENV !== 'production') {
    // Show a kitchen sink
    if (kitchenSink) {
      return require('./debug').KitchenSink;
    }
  }
  const name = config?.interface?.name;
  return getComponentForRoute(name);
}

export function getComponentForRoute(name: string) {
  const interfacePathBuilders = interfacePaths(name);

  let esModule;
  while (!esModule && interfacePathBuilders.length > 0) {
    const interfacePathBuilder = interfacePathBuilders.shift()!;
    const interfacePath = interfacePathBuilder;
    try {
      esModule = requireInterface(interfacePath);
    } catch (err) {
      if (err.code !== 'MODULE_NOT_FOUND') {
        throw err;
      }
    }
  }

  if (!esModule) {
    return routingError('notFound', name);
  }

  // citadel edit: we prefer using folders and therefore directly /route/to/Folder.tsx,
  //               so it needs to remove the path segments.
  const nameHasABackslash = name.lastIndexOf("/");
  const realName = nameHasABackslash === -1 ? name : name.substring(nameHasABackslash + 1);
  const Component = esModule[realName];
  if (!Component) {
    return routingError('missingExport', name);
  }

  return Component;
}
