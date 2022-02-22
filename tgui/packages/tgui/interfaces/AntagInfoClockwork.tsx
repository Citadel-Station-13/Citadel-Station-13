import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { Window } from '../layouts';

interface Info {
  HONOR_RATVAR: BooleanLike;
}

let REC_RATVAR = "";
// You may ask "why is this not inside ClockworkSlab"
// It's because cslab gets called every time. Lag is bad.
for (let index = 0; index < Math.min(Math.random()*100); index++) {
  REC_RATVAR += "HONOR RATVAR ";
}

export const AntagInfoClockwork = (props, context) => {
  const { data } = useBackend<Info>(context);
  const {
    HONOR_RATVAR = false,
  } = data;
  return (
    <Window
      width={400}
      height={400}
      theme="clockcult">
      <Window.Content>
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontFamily="Times New Roman" fontSize={2}>
              Chetr nyy hagehguf naq ubabe Ratvar.
            </Stack.Item>
            <Stack.Item fontSize={1.2} color="#BE8700">
              {`Assist your new companions in their righteous efforts.
                Your goal is theirs, and theirs yours.
                You serve the Clockwork Justiciar above all else.`}
            </Stack.Item>
            <br />
            <Stack.Item>
              <Section
                title="This is Ratvar's will"
                vertical
                fill>
                <Stack.Item grow >
                  {HONOR_RATVAR ? (
                    <Stack.Item
                      textColor="#BE8700"
                      fontSize={2}
                      bold>
                      {REC_RATVAR}
                    </Stack.Item>
                  ) : (
                    <Stack.Item
                      textColor="#dab44d"
                      fontSize={2}
                      bold>
                      Construct the Ark of the
                      Clockwork Justicar and free Ratvar.
                    </Stack.Item>
                  )}
                </Stack.Item>
              </Section>
            </Stack.Item>
            <br />
            <Stack.Divider />
            <Stack.Item fontSize={2} color="#BE8700" bold>
              Perform his every whim without hesitation.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
