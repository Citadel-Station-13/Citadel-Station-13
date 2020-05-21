import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { toFixed } from 'common/math';
import { RADIO_CHANNELS } from '../constants';
import { Button, LabeledList, NumberInput, NoticeBox, Section, Input } from '../components';

export const TeleInteract = props => {
  const { act, data } = useBackend(props);
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
  } = machine;
  const isrelay = (machine && machine.broadcast && machine.receiving);
  const isbus = (machine && machine.chang_frequency);
  return (
    <Fragment>
      {!!notice && (
        <NoticeBox>
          {notice}
        </NoticeBox>
      )}
      <Section title="Network Access">
        <LabeledList>
          <LabeledList.Item
            label="Power Status"
            color={power ? 'good' : 'bad'}>
            {power ? 'On' : 'Off'}
          </LabeledList.Item>
          {power && (
            <Fragment>
              <LabeledList.Item label="Identification String:">
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
              {isrelay && (
                <Fragment>
                  <LabeledList.Item label="Broadcasting">
                    <Input
                      value={machine.broadcast}
                      width="150px"
                      maxLength={15}
                      onChange={(e, value) => act('relay', {
                        'broadcast': value,
                      })} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Receiving">
                    <Input
                      value={machine.receiving}
                      width="150px"
                      maxLength={15}
                      onChange={(e, value) => act('relay', {
                        'receiving': value,
                      })} />
                  </LabeledList.Item>
                </Fragment>
              )}
              {isbus && (
                <LabeledList.Item label="Change Signal Frequency">
                  <NumberInput
                    animate
                    unit="kHz"
                    step={0.2}
                    stepPixelSize={10}
                    minValue={1337 / 10}
                    maxValue={1599 / 10}
                    value={machine.chang_frequency / 10}
                    format={value => toFixed(value, 1)}
                    onDrag={(e, value) => act('frequency', {
                      adjust: (value - machine.chang_frequency / 10),
                    })} />
                </LabeledList.Item>
              )}
              {hidden && (
                <LabeledList.Item label="Shadow Link">
                  {'ACTIVE'}
                </LabeledList.Item>
              )}
              {multitool && (
                <LabeledList.Item
                  label="Multitool buffer"
                  buttons={multitool_buf ? (
                    <Fragment>
                      <Button
                        content="Link"
                        onClick={() => act('multitool', {
                          'Link': true,
                        })}
                      />
                      <Button
                        content="Flush"
                        onClick={() => act('multitool', {
                          'Flush': true,
                        })}
                      />
                    </Fragment>
                  ):(
                    <Button
                      content="Add Machine"
                      onClick={() => act('multitool', {
                        'Add': true,
                      })}
                    />
                  )}>
                  {multitool_buf ? (
                    `${multitool_buf.name} ${multitool_buf.id}`
                  ) : (
                    'Add Machine'
                  )}
                </LabeledList.Item>
              )}
            </Fragment>
          )}
        </LabeledList>
        {power && (
          <Fragment>
            <Section
              title="Linked Network Entities"
              level={2}>
              <LabeledList>
                {links.map(entity => {
                  return (
                    <LabeledList.Item
                      key={entity.name}
                      label={entity.ref}
                      buttons={(
                        <Button
                          content="Remove"
                          onClick={() => act('links', {
                            'value': entity.ref,
                          })}
                        />
                      )}>
                      {`${entity.name} (${entity.id})`}
                    </LabeledList.Item>
                  );
                })}
              </LabeledList>
            </Section>
            <Section
              title="Filtering Frequencies"
              level={2}>
              <Button
                content="Add Filter"
                onClick={() => act('freq', {
                  'add': true,
                })}
              />
              <LabeledList>
                {(freq_listening && freq_listening.length) && (
                  freq_listening.map(thing => {
                    const valid = RADIO_CHANNELS
                      .find(channel => channel.freq === thing);
                    return (
                      <Fragment
                        key={thing}>
                        {(valid) ? (
                          <span style={`color: ${valid.color}`}>
                            {`[${thing}] (${valid.name}) `}
                          </span>
                        ) : (
                          `[${thing}] `
                        )}
                        <Button
                          content="Remove"
                          onClick={() => act('freq', {
                            'remove': thing,
                          })}
                        />
                      </Fragment>
                    );
                  })
                )}
              </LabeledList>
            </Section>
          </Fragment>
        )}
      </Section>
    </Fragment>
  );
};
