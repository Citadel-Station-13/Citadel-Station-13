import { Window } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Tabs, Input } from '../components';


export const ClockworkSlab = props => {
  const { act, data } = useBackend(props);
  const {
    recollection,
    rec_text,
    recollection_categories,
    rec_section,
    rec_binds,
  } = data;

  return (
    <Window
      theme="clockwork"
      resizable>
      <Section>
        <Button
          content={recollection ? "Recital" : "Recollection"}
          onClick={() => act('toggle')}
        />
      </Section>
      {!!recollection && (
        <Section title="Recollection">
          {rec_text}
          {recollection_categories.map(categories => {
            return (
              <Window>
                <br key={category.name} />
                <Button
                  content={`${categories.name} - ${categories.desc}`}
                  onClick={() => act('rec_category', {
                    "category": categories.name,
                  })} />
              </Window>
            );
          })}
          {rec_section}
          {rec_binds}
        </Section>
      )}
      {recollection && (
        <Window>
          <Section title="Power">
            {data.power}
          </Section>
          <Section title="Recital">
            {data.tier_info}
            {data.scripturecolors}
            <Tabs>
              <Tabs.Tab
                key="driver"
                label="Driver">
                {() => (
                  <Section>
                    <LabeledList>
                      {data.scripture.driver.map(script => {
                        return (
                          <LabeledList.Item
                            key={script.name}
                            label={script.name}
                            buttons={(
                              <Window>
                                <Button
                                  content={`Recite (${script.required} W)`}
                                  onClick={() => act('recite', {
                                    'category': script.name,
                                  })} />
                                <Button
                                  content={script.quickbind
                                    ? `Unbind ${script.quickbind}`
                                    : 'Quickbind'}
                                  onClick={() => act('bind', {
                                    'category': script.name,
                                  })} />
                              </Window>
                            )}>
                            {`${script.descname} ${script.invokers}`}
                          </LabeledList.Item>
                        );
                      })}
                    </LabeledList>
                  </Section>
                )}
              </Tabs.Tab>
              <Tabs.Tab
                key="script"
                label="Script">
                {() => (
                  <Section>
                    <LabeledList>
                      {data.scripture.script.map(script => {
                        return (
                          <LabeledList.Item
                            key={script.name}
                            label={script.name}
                            buttons={(
                              <Window>
                                <Button
                                  content={`Recite (${script.required} W)`}
                                  onClick={() => act('recite', {
                                    'category': script.name,
                                  })} />
                                <Button
                                  content={script.quickbind
                                    ? `Unbind ${script.quickbind}`
                                    : 'Quickbind'}
                                  onClick={() => act('bind', {
                                    'category': script.name,
                                  })} />
                              </Window>
                            )}>
                            {`${script.descname} ${script.invokers}`}
                          </LabeledList.Item>
                        );
                      })}
                    </LabeledList>
                  </Section>
                )}
              </Tabs.Tab>
              <Tabs.Tab
                key="application"
                label="Application">
                {() => (
                  <Section>
                    <LabeledList>
                      {data.scripture.application.map(script => {
                        return (
                          <LabeledList.Item
                            key={script.name}
                            label={script.name}
                            buttons={(
                              <Window>
                                <Button
                                  content={`Recite (${script.required} W)`}
                                  onClick={() => act('recite', {
                                    'category': script.name,
                                  })} />
                                <Button
                                  content={script.quickbind
                                    ? `Unbind ${script.quickbind}`
                                    : 'Quickbind'}
                                  onClick={() => act('bind', {
                                    'category': script.name,
                                  })} />
                              </Window>
                            )}>
                            {`${script.descname} ${script.invokers}`}
                          </LabeledList.Item>
                        );
                      })}
                    </LabeledList>
                  </Section>
                )}
              </Tabs.Tab>
            </Tabs>
          </Section>
        </Window>
      )}
    </Window>
  );
};
