import { useBackend } from '../backend';
import { Button, ProgressBar, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export const VrSleeper = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={475}
      height={340}>
      <Window.Content>
        {!!data.emagged && (
          <Section>
            <Box color="bad">
              Safety restraints disabled.
            </Box>
          </Section>
        )}

        <Section title={"Virtual Avatar"}>
          {data.vr_avatar ? (
            <LabeledList>
              <LabeledList.Item
                label={"Name"} >
                {data.vr_avatar.name}
              </LabeledList.Item>
              <LabeledList.Item
                label={"Status"} >
                {data.vr_avatar.status}
              </LabeledList.Item>
              {!!data.vr_avatar && (
                <LabeledList.Item
                  label={"Health"} >
                  {<ProgressBar
                    value={data.vr_avatar.health / data.vr_avatar.maxhealth}
                    ranges={{
                      good: [0.9, Infinity],
                      average: [0.7, 0.8],
                      bad: [-Infinity, 0.5],
                    }} />}
                </LabeledList.Item>
              )}
            </LabeledList>
          ) : (
            "No Virtual Avatar detected"
          )}
        </Section>
        <Section title="VR Commands">
          <Button
            icon={data.toggle_open ? 'unlock' : 'lock'}
            disabled={data.stored < data.max}
            onClick={() => act('toggle_open')}>
            {data.toggle_open
              ? 'Close VR Sleeper'
              : 'Open VR Sleeper'}
          </Button>
          <Section>
            {data.isoccupant ? (
              <Button.Confirm
                color={'blue'}
                onClick={() => {
                  act('vr_connect');
                  act('tgui:close');
                }}
                icon={'unlock'}>
                Connect to VR
              </Button.Confirm>
            ) : (
              "You need to be inside the VR sleeper to connect to VR"
            )}
          </Section>
          {!!data.vr_avatar && (
            <Button
              icon={'recycle'}
              onClick={() => {
                act('delete_avatar');
              }}>
              Delete VR avatar
            </Button>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
