import { useBackend } from "../backend";
import { Icon, Section, Table } from "tgui-core/components";
import { Window } from "../layouts";

const commandJobs = [
  "Captain",
  "Head of Personnel",
  "Head of Security",
  "Chief Engineer",
  "Research Director",
  "Chief Medical Officer",
];

export const CrewManifest = (props) => {
  const { data: { manifest, positions } } = useBackend<any>();

  return (
    <Window title="Crew Manifest" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([department, crew]) => (
          <Section
            className={"CrewManifest--" + department}
            key={department}
            title={
              `${department} (${positions[department]} positions open)`
            }
          >
            <Table>
              {Object.entries((crew as any)).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell className={"CrewManifest__Cell"}>
                    {(crewMember as any).name}
                  </Table.Cell>
                  <Table.Cell
                    className={
                      "CrewManifest__Cell CrewManifest__Cell--"
                      + ((crewMember as any).rank === "Captain" ? "Captain" : "Command")
                    }
                    collapsing
                  >
                    {commandJobs.includes((crewMember as any).rank) && (
                      <Icon
                        name={
                          (crewMember as any).rank === "Captain" ? "star" : "chevron-up"
                        }
                      />
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={"CrewManifest__Cell"}
                    collapsing
                    color="label"
                  >
                    {(crewMember as any).rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
