import { useState } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_name: string;
  current_assignment: string;
  current_trim: string;
  current_age: number;
  currently_wallet_spoofing: BooleanLike;
};

type TextInputSectionProps = {
  holding_section: typeof Section;
};



const NameSection = (
  initial_value: string) =>
    {

    }

const AssignmentSection = (
  initial_value: string) => {

    const TrimSection = (
      initial_value: number) => {

const SpoofingSection = (
  initial_value: BooleanLike) => {

const AgeSection = (
  initial_value: number) => {


const ForgedSection = (
  section_to_forge: string,
  initial_value: string | number | BooleanLike,
  props
) => {
  const { act, data } = useBackend<Data>();

  const [fieldModified, setFieldModified] = useState<string>(section_to_forge);
  const [fieldValue, setFieldValue] = useState<string | number | BooleanLike>(
    initial_value,
  );

  const [randomizableToggle, setRandomizableToggle] =
    useState<BooleanLike>(false);

  const Randomize = (to_randomize: string) => {
    return (
      act('randomize', { to_randomize: fieldModified })
    );
  };

  return (
    <Stack.Item>
      <Section
        title={section_to_forge.charAt(0).toUpperCase() + section_to_forge.slice(1)}
      >
        <Button onClick={() => Randomize(section_to_forge)}>
          Randomize
        </Button>
      </Section>
    </Stack.Item>
  );
};

export const ChameleonCardForge = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    current_name,
    current_assignment,
    current_trim,
    current_age,
    currently_wallet_spoofing,
  } = data;

  return (
    <Window width={500} height={300} theme="syndicate">
      <Window.Content fitted>
        <Stack vertical inlineFlex justify="space-between">
          <Stack.Item>
            <Stack inlineFlex justify="space-between">
              <Stack.Item>
                <Section />
              </Stack.Item>
              <Stack.Item>
                <Section />
              </Stack.Item>
              <Stack.Item>
                <Section />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack inlineFlex justify="space-between">
              <Stack.Item>
                <Section />
              </Stack.Item>
              <Stack.Item>
                <Section />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
