import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { Fragment } from 'inferno';

const skillgreen = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

const skillyellow = {
  color: '#FFDB58',
  fontWeight: 'bold',
};

export const SkillPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const skills = data.skills || [];
  return (
    <Window
      title="Manage Skills"
      width={600}
      height={500}
      resizable>
      <Window.Content scrollable>
        <Section title={skills.playername}>
          <LabeledList>
            {skills.map(skill => (
              <LabeledList.Item
                key={skill.name}
                label={skill.name}>
                <span style={skillyellow}>
                  {skill.desc}
                </span>
                <br />
                {!!skill.level_based && (
                  <Fragment>
                    <Level
                      skill_lvl_num={skill.lvl_base_num}
                      skill_lvl={skill.lvl_base} />
                    <br />
                  </Fragment>
                )}
                Total Experience: [{skill.value_base} XP]
                <br />
                XP To Next Level:
                {skill.level_based ? (
                  <span>
                    {skill.xp_next_lvl_base}
                  </span>
                ) : (
                  <span style={skillgreen}>
                    [MAXXED]
                  </span>
                )}
                <br />
                {skill.base_readout}
                <ProgressBar
                  value={skill.percent_base}
                  color="good" />
                <br />
                {!!data.admin && (
                  <Fragment>
                    <Button
                      content="Adjust Exp"
                      onClick={() => act('adj_exp', {
                        skill: skill.path,
                      })} />
                    <Button
                      content="Set Exp"
                      onClick={() => act('set_exp', {
                        skill: skill.path,
                      })} />
                    <Button
                      content="Set Level"
                      onClick={() => act('set_lvl', {
                        skill: skill.path,
                      })} />
                    <br />
                    <br />
                  </Fragment>
                )}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

const Level = props => {
  const {
    skill_lvl_num,
    skill_lvl,
  } = props;
  return (
    <Box inline>
      Level: [
      <Box
        inline
        bold
        textColor={`hsl(${skill_lvl_num * 50}, 50%, 50%)`}>
        {skill_lvl}
      </Box>
      ]
    </Box>
  );
};
const XPToNextLevel = props => {
  const {
    xp_req,
    xp_prog,
  } = props;
  if (xp_req === 0) {
    return (
      <span style={skillgreen}>
        to next level: MAXXED
      </span>
    );
  }
  return (
    <span>XP to next level: [{xp_prog} / {xp_req}]</span>
  );
};

