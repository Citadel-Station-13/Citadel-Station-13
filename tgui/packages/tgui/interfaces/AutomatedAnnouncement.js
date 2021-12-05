import { multiline } from 'common/string';
import { useBackend } from '../backend';
import { Button, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const TOOLTIP_TEXT = multiline`
  %PERSON will be replaced with their name.
  %RANK with their job.
`;

export const AutomatedAnnouncement = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    arrivalToggle,
    arrival,
    newheadToggle,
    newhead,
    latecryoToggle,
    latecryo,
    latevoreToggle,
    latevore,
  } = data;
  return (
    <Window
      title="Automated Announcement System"
      width={500}
      height={330}>
      <Window.Content>
        <Section
          title="Arrival Announcement"
          buttons={(
            <Button
              icon={arrivalToggle ? 'power-off' : 'times'}
              selected={arrivalToggle}
              content={arrivalToggle ? 'On' : 'Off'}
              onClick={() => act('ArrivalToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Message"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={arrival}
                onChange={(e, value) => act('ArrivalText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Departmental Head Announcement"
          buttons={(
            <Button
              icon={newheadToggle ? 'power-off' : 'times'}
              selected={newheadToggle}
              content={newheadToggle ? 'On' : 'Off'}
              onClick={() => act('NewheadToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Message"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={newhead}
                onChange={(e, value) => act('NewheadText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Cryogenic Awakening Announcement"
          buttons={(
            <Button
              icon={latecryoToggle ? 'power-off' : 'times'}
              selected={latecryoToggle}
              content={latecryoToggle ? 'On' : 'Off'}
              onClick={() => act('LateCryoToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Message"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={latecryo}
                onChange={(e, value) => act('LateCryoText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Unknown Method Announcement"
          buttons={(
            <Button
              icon={latevoreToggle ? 'power-off' : 'times'}
              selected={latevoreToggle}
              content={latevoreToggle ? 'On' : 'Off'}
              onClick={() => act('LateVoreToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Message"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={latevore}
                onChange={(e, value) => act('LateVoreText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
