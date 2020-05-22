import { useBackend } from '../backend';
import { round } from 'common/math';
import { map } from 'common/collections';
import { Section, Tabs, LabeledList, Button } from '../components';
import { Fragment } from 'inferno';
import { Window } from '../layouts';

export const ClockworkSlab = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recollection = true,
    recollection_categories = [],
    scripture = null,
    power = 0,
  } = data;
  return (
    <Window>
      <Window.Content>
        <Fragment theme="clockwork">
          <Section>
            <Button
              content={recollection
                ? "Recital"
                : "Recollection"}
              onClick={() => act('toggle')}
            />
          </Section>
          {recollection ? ( // tutorial
            <Section title="Recollection">
              {data.rec_text}
              {recollection_categories.map(cat => {
                return (
                  <Fragment key={cat.name} >
                    <br />
                    <Button
                      content={`${cat.name} - ${cat.desc}`}
                      onClick={() => act('rec_category', {
                        "category": cat.name,
                      })} />
                  </Fragment>
                );
              })}
              {data.rec_section}
              {data.rec_binds}
            </Section>
          ) : (
            <Fragment>
              <Section title="Power">
                <b>
                  {power <= 1000 ? (
                    `${power} W`
                  ) : (
                    `${round(power/1000, 2)} kW`
                  )}
                </b>
              </Section>
              <Section title="Recital">
                {data.tier_info}
                {data.scripturecolors}
                <Tabs>
                  {map((cat_contents, category) => {
                    const contents = cat_contents || [];
                    return (
                      <Tabs.Tab
                        key={category}
                        label={category}>
                        <Section>
                          <LabeledList>
                            {contents.map(script => {
                              return (
                                <LabeledList.Item
                                  key={script.name}
                                  label={script.name}
                                  buttons={(
                                    <Fragment>
                                      <Button
                                        content={`Recite
                                        (${script.required} W)`}
                                        disabled={script.required < power}
                                        onClick={() => act('recite', {
                                          'script': script.name,
                                        })} />
                                      <Button
                                        content={script.quickbind ? (
                                          `Unbind ${script.quickbind}`
                                        ) : (
                                          'Quickbind'
                                        )}
                                        onClick={() => act('bind', {
                                          'script': script.name,
                                        })} />
                                    </Fragment>
                                  )}>
                                  {`${script.descname} ${script.invokers}`}
                                </LabeledList.Item>
                              );
                            })}
                          </LabeledList>
                        </Section>
                      </Tabs.Tab>
                    );
                  })(scripture)}
                </Tabs>
              </Section>
            </Fragment>
          )}
        </Fragment>
      </Window.Content>
    </Window>
  );
};
