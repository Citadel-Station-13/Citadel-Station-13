import { filter } from 'common/collections';
import { useBackend } from '../backend';
import { Button, Icon, Input, Section, Stack, Tabs } from '../components';
import { useLocalState } from '../backend';
import { Window } from '../layouts';

export const AIAnnouncement = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    last_announcement,
    vox_types = {},
  } = data;

  const [
    current_page,
    set_page,
  ] = useLocalState(context, 'current_page', 0);

  const [
    announcement_input,
    set_announcement_input,
  ] = useLocalState(context, 'announcement_input', last_announcement);

  // I love `Object`s!!
  const words_filtered = Object.keys(vox_types[Object.keys(vox_types)[current_page]]);

  const search_split = announcement_input.split(" ").filter(element => element);

  const missing_words = search_split.map(element => words_filtered.includes(element) ? null : element).filter(element => element);

  return (
    <Window
      width={630}
      height={175}
      resizable
      title="Vox Announcement">
      <Window.Content>
        <Section fill overflow="auto">
          <Stack vertical>
            <Stack.Item>
              <font color="red">WARNING:</font> Misuse of this verb can result in you being job banned. More help is available in &apos;Announcement Help&apos;
            </Stack.Item>
            <Stack.Item>
              <Tabs fluid textAlign="center">
                {
                  Object.keys(vox_types).map((vox_type, index) => (
                    <Tabs.Tab
                      key={index}
                      onClick={() => set_page(index)}
                      selected={current_page === index}>
                      {vox_type}
                    </Tabs.Tab>
                  ))
                }
              </Tabs>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={last_announcement}
                    placeholder="Announce something..."
                    onInput={(e, value) => set_announcement_input(value)}
                    onEnter={(e, value) => act("announce", {
                      "vox_type": Object.keys(vox_types)[current_page],
                      "to_speak": value,
                    })}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button icon="volume-high" mt={-0.2} onClick={() => act("announce", {
                    "vox_type": Object.keys(vox_types)[current_page],
                    "to_speak": announcement_input,
                  })} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              {missing_words.length
                ? <div>These words are not available on the announcement system: <font color="red">{missing_words.join(" ")}</font></div> : null}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
