/**
 * @file
 * @license MIT
 */

import { Stack } from "tgui-core/components";

export const LoadingScreen = (props: {}, context) => {
  return (
    <Stack fill>
      {/* TODO: actually good icon */}
      <Stack.Item grow={1} />
      <Stack.Item>
        <h1 style={{ textAlign: "center" }}>
          Loading...
        </h1>
      </Stack.Item>
      <Stack.Item grow={1} />
    </Stack>
  );
};
