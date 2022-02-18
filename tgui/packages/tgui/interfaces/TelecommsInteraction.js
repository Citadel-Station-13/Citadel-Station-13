/**
 * @file
 * @copyright 2020 LetterN (https://github.com/LetterN)
 * @license MIT
 */
import { Window } from '../layouts';
import { useBackend } from '../backend';
import { toFixed } from 'common/math';
import { RADIO_CHANNELS } from '../constants';
import { Button, LabeledList, NumberInput, NoticeBox, Section, Input } from '../components';

export const TelecommsInteraction = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    notice = "",
    multitool = false,
    multitool_buf = null,
    machine = null,
    links = [],
    freq_listening = [],
  } = data;
  const {
    power = false,
    id = "NULL",
    network,
    prefab = false,
    hidden = false,
    isrelay = false,
    isbus = false,
  } = machine;
  return (
    <Window
      resizable
      width={520}
      height={500}>
      <Window.Content scrollable>
        <>
          {!!notice && (
            <NoticeBox>
              {notice}
            </NoticeBox>
          )}
          <Section title="Network Access">
            <LabeledList>
              <LabeledList.Item label="Power Status">
                <Button
                  icon={power ? 'power-off' : 'times'}
                  color={power ? 'good' : 'bad'}
                  onClick={() => act('toggle')}>
                  {power ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              {!!power && (
                <>
                  <LabeledList.Item label="Identification String">
                    <Input
                      value={id}
                      width="150px"
                      maxLength={255}
                      onChange={(e, value) => act('machine', {
                        'id': value,
                      })} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Network">
                    <Input
                      value={network}
                      width="150px"
                      maxLength={15}
                      onChange={(e, value) => act('machine', {
                        'network': value,
                      })} />
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Prefabrication"
                    color={power ? 'good' : 'bad'}>
                    {prefab ? 'TRUE' : 'FALSE'}
                  </LabeledList.Item>
                  {!!isrelay && (
                    <>
                      <LabeledList.Item label="Broadcasting">
                        <Button
                          icon={machine.broadcast ? 'check' : 'times'}
                          color={machine.broadcast ? 'good' : 'bad'}
                          onClick={() => act('relay', {
                            'broadcast': true,
                          })}>
                          {machine.broadcast ? 'YES' : 'NO'}
                        </Button>
                      </LabeledList.Item>
                      <LabeledList.Item label="Receiving">
                        <Button
                          icon={machine.receiving ? 'check' : 'times'}
                          color={machine.receiving ? 'good' : 'bad'}
                          onClick={() => act('relay', {
                            'receiving': true,
                          })}>
                          {machine.receiving ? 'YES' : 'NO'}
                        </Button>
                      </LabeledList.Item>
                    </>
                  )}
                  {!!isbus && (
                    <LabeledList.Item label="Change Signal Frequency">
                      <Button
                        icon={machine.chang_frequency ? 'power-off' : 'times'}
                        color={machine.chang_frequency ? 'good' : 'bad'}
                        onClick={() => act('frequency', {
                          'toggle': true,
                        })}>
                        {machine.chang_frequency ? (
                          'Enabled'
                        ) : (
                          'Disabled'
                        )}
                      </Button>
                      {!!machine.chang_frequency && (
                        <NumberInput
                          animate
                          unit="kHz"
                          step={0.2}
                          stepPixelSize={10}
                          minValue={1201 / 10}
                          maxValue={1599 / 10}
                          value={machine.chang_freq_value / 10}
                          format={value => toFixed(value, 1)}
                          onChange={(e, value) => act('frequency', {
                            'adjust': value,
                          })} />
                      )}
                    </LabeledList.Item>
                  )}
                  {!!hidden && (
                    <LabeledList.Item label="Shadow Link">
                      {'ACTIVE'}
                    </LabeledList.Item>
                  )}
                  {!!multitool && (
                    <LabeledList.Item
                      label="Multitool buffer"
                      buttons={multitool_buf ? (
                        <>
                          <Button
                            onClick={() => act('multitool', {
                              'Link': true,
                            })}>
                            Link
                          </Button>
                          <Button
                            onClick={() => act('multitool', {
                              'Flush': true,
                            })}>
                            Flush
                          </Button>
                        </>
                      ) : (
                        <Button
                          onClick={() => act('multitool', {
                            'Add': true,
                          })}>
                          Add Machine
                        </Button>
                      )}>
                      {!!multitool_buf && (
                        `${multitool_buf.name} (${multitool_buf.id})`
                      )}
                    </LabeledList.Item>
                  )}
                </>
              )}
            </LabeledList>
            {!!power && (
              <>
                <Section
                  title="Linked Network Entities"
                  level={2}>
                  <LabeledList>
                    {links.map(entity => (
                      <LabeledList.Item
                        key={entity.name}
                        label={entity.ref}
                        buttons={(
                          <Button
                            onClick={() => act('unlink', {
                              'value': entity.ref,
                            })}>
                            Remove
                          </Button>
                        )}>
                        {`${entity.name} (${entity.id})`}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                </Section>
                <Section
                  title="Filtering Frequencies"
                  level={2}>
                  <Button
                    onClick={() => act('freq', {
                      'add': true,
                    })}>
                    Add Filter
                  </Button>
                  <br />
                  <br />
                  {(freq_listening && freq_listening.length) ? (
                    freq_listening.map(thing => {
                      const valid = RADIO_CHANNELS
                        .find(channel => channel.freq === thing);
                      return (
                        <Button
                          key={thing}
                          icon="times"
                          onClick={() => act('freq', {
                            'remove': thing,
                          })}>
                          {valid ? (
                            <span style={`color: ${valid.color}`}>
                              {`${thing} (${valid.name})`}
                            </span>
                          ) : (
                            thing
                          )}
                        </Button>
                      );
                    })
                  ) : (
                    ''
                  )}
                </Section>
              </>
            )}
          </Section>
        </>
      </Window.Content>
    </Window>
  );
};
