import { useBackend } from '../backend';
import { Button, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const VrSleeper = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window>
      <Window.Content>
        {!!data.emagged === 1 && (
          <span>Safety restraints disabled.</span>
        )}
        {!!data.vr_avatar && (
          <ProgressBar
            title={"Avatar Health: "}
            value={data.vr_avatar.maxhealth / 100}
            ranges={{
              good: [90, Infinity],
              average: [70, 89],
              bad: [-Infinity, 69],
            }} />
        )}
        <Section
          title="VR Commands">
          buttons={(
            <Button
              content={data.toggle_open
                ? 'Open VR Sleeper'
                : 'Close VR Sleeper'}
              icon={data.toggle_open ? 'lock' : 'unlock'}
              disabled={data.stored < data.max}
              onClick={() => act('toggle_open')} />
          )}
          {!!data.isoccupant && (
            <Button
              content={'Connect to VR'}
              onClick={() => act('vr_connect')}
              icon={'unlock'} />
          ) || ("You need to be inside the VR sleeper to connect to VR"
          )}
          {!!data.vr_avatar && (
            <Button
              content={"Delete VR avatar"}
              icon={'recycle'}
              onClick={() => act('delete_avatar')} />
          ) || ("VR avatar not detected."
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
