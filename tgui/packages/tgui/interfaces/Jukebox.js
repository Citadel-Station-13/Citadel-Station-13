import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend } from '../backend';
import { Box, Button, Dropdown, Section, Knob, LabeledControls, LabeledList, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const Jukebox = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    active,
    track_selected,
    track_length,
    volume,
    is_emagged,
    cost_for_play,
    has_access,
  } = data;
  const songs = flow([
    sortBy(
      song => song.name),
  ])(data.songs || []);
  const queued_tracks = data.queued_tracks || [];
  return (
    <Window
      width={420}
      height={480}>
      <Window.Content>
        <Section
          title="Machine Controls"
          buttons={(
            <Button
              icon={active ? 'pause' : 'play'}
              content={active ? 'Stop' : 'Play'}
              selected={active}
              disabled={!has_access}
              onClick={() => act('toggle')} />
          )}>
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Current Track">
                  {track_selected ? track_selected : "No Track Selected"}
                </LabeledList.Item>
                <LabeledList.Item label="Track Length">
                  {track_selected ? track_length : "No Track Selected"}
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <LabeledControls justify="center">
                <LabeledControls.Item label="Volume">
                  <Box position="relative">
                    <Knob
                      size={2.4}
                      color={volume > 140 ? 'red' : 'green'}
                      value={volume}
                      unit="%"
                      minValue={0}
                      maxValue={is_emagged ? 210 : 100}
                      step={1}
                      stepPixelSize={1}
                      disabled={!has_access}
                      onDrag={(e, value) => act('set_volume', {
                        volume: value,
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="62px"
                      color="transparent"
                      icon="fast-backward"
                      disabled={!has_access}
                      onClick={() => act('set_volume', {
                        volume: "min",
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="-8px"
                      color="transparent"
                      icon="fast-forward"
                      disabled={!has_access}
                      onClick={() => act('set_volume', {
                        volume: "max",
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="67px"
                      right="84px"
                      color="transparent"
                      icon="undo"
                      disabled={!has_access}
                      onClick={() => act('set_volume', {
                        volume: "reset",
                      })} />
                  </Box>
                </LabeledControls.Item>
              </LabeledControls>
            </Stack.Item>
          </Stack>
          <LabeledList>
            <LabeledList.Item label="Cost to Queue">
              {cost_for_play} CR {has_access ? "(Cost waived)" : ""}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section fill vertical>
          <Stack>
            <Stack.Item grow>
              <Dropdown
                width="100%"
                overflow-y="scroll"
                options={songs.map(song => song.name)}
                selected="Select a Track"
                onSelected={value => act('select_track', {
                  track: value,
                })} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="play"
                content="Queue"
                onClick={() => act('add_to_queue')}
              />
            </Stack.Item>
          </Stack>
          <Section fill vertical>
            <Tabs vertical>
              {queued_tracks.map(song => (
                <Tabs.Tab
                  key={song.name}
                >
                  {song.name}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
