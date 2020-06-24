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
    <Window theme="clockcult" >
      <Window.Content>
        <Fragment>
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
                <b>${power}</b>
              </Section>
              <Section title="Recital">
                {data.tier_info}
                {data.scripturecolors}
                <Tabs>
                {scripture.map(category => {
                    const script = category|| [];
                    return (

                        <Section>
                          <LabeledList>
                                <LabeledList.Item
                                  key={script.name}
                                  label={script.important ? `<b>${script.name}</b>` : script.name}
                                  buttons={(
                                    <Fragment>
                                      <Button
                                        content={`Recite ${script.required}`}
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
                                  {`${script.descname || ""} ${script.invokers || 1}`}
                                </LabeledList.Item>

                          </LabeledList>
                        </Section>
                    );
                  })}
                </Tabs>
              </Section>
            </Fragment>
          )}
        </Fragment>
      </Window.Content>
    </Window>
  );
};
