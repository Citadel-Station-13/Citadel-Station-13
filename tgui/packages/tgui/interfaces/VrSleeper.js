import { useBackend } from '../backend';
import { Button, ProgressBar, Section, Box } from '../components';
import { Window } from '../layouts';

export const VrSleeper = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window>
      <Window.Content>
        {!!data.emagged && (
          <Section>
            <Box color="bad">
              Safety restraints disabled.
            </Box>
          </Section>
        )}
        {!!data.vr_avatar && (
          <Section title={"Virtual Avatar"}>
            <ProgressBar
              title={"Avatar Status: "}
              value={data.vr_avatar.maxhealth / 100}
              ranges={{
                good: [90, Infinity],
                average: [70, 89],
                bad: [-Infinity, 69],
              }} />
          </Section>
        ) && (
          <Section>
            <Box>
              No Avatar detected
            </Box>
          </Section>
        )}
        <Section title="VR Commands">
          <Button
            content={data.toggle_open
              ? 'Close VR Sleeper'
              : 'Open VR Sleeper'}
            icon={data.toggle_open ? 'unlock' : 'lock'}
            disabled={data.stored < data.max}
            onClick={() => act('toggle_open')} />
          <Section>
            {!!data.isoccupant && (
              <Button.Confirm
                color={'blue'}
                content={'Connect to VR'}
                onClick={() => {
                  act('vr_connect');
                  act('tgui:close');
                }}
                icon={'unlock'} />
            )
          || ("You need to be inside the VR sleeper to connect to VR")}
          </Section>
          {!!data.vr_avatar && (
            <Button
              content={"Delete VR avatar"}
              icon={'recycle'}
              onClick={() => {
                act('delete_avatar');
                act('tgui:update');
              }} />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
