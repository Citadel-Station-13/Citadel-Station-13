import { useBackend } from '../backend';
import { Window } from '../layouts';
import { AtmosPowerControl } from './common/AtmosComponent';

export const AtmosPump = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={335}
      height={115}>
      <Window.Content>
        <AtmosPowerControl />
      </Window.Content>
    </Window>
  );
};
