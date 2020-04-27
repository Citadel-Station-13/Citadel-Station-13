import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { Fragment } from 'inferno';

export const ClockworkSlab = (props, context) => {
  const { data } = useBackend(context);
  const { power } = data;
  return (
    <Window
      theme="syndicate"
      resizable>
      <Window.Content scrollable>
        <GenericSlab
         Content={power} />
      </Window.Content>
    </Window>
  );
};
