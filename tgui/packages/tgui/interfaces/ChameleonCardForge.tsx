import { useState } from 'react';
import { Input, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Gender } from './PreferencesMenu/preferences/gender';

type Data = {
  registered_name: string;
  assignment: string;
  trim_override: number;
  age: number;
  is_wallet_spoofing: BooleanLike;
  gender_presented: Gender;
};

const SectionTitles: Record<string, string> = {
  registered_name: 'Current Name',
  assignment: 'Current Assignment',
  trim_override: 'Current Trim',
  age: 'Current Age',
  is_wallet_spoofing: 'Wallet Spoofing?',
  gender: 'Current Gender',
};

type EntrySubsectionTemplate = Record<
  string,
  (props: {
    label: string;
    value: string | number | boolean | Gender;
  }) => React.ReactNode
>;

const EntrySubsectionFactory: EntrySubsectionTemplate = {
  registered_name: (props: { label: string, value: string }) => (
    TextEntrySection(props)
  ),
  assignment: (props: {label: string, value: string}) => (
    TextEntrySection(props)
  ),
  trim_override: (props: {label: string, value: number}) => (
    DropdownEntrySection
  ),
};

const EntrySection = (props) => {
  const { label, value } = props;

  return (
    <Section title={SectionTitles[label]}>
      {EntrySubsectionFactory[label](props)}
    </Section>
  );
};

const TextEntrySection = (props: { label: string; value: string }) => {
  const { label, value } = props;
  const { act } = useBackend<Data>();
  const [currentValue, setCurrentValue] = useState(value);
  const WasChanged = (valueToCheck: string) => {
    if (valueToCheck !== currentValue) {
      setCurrentValue(valueToCheck); // Update local state

      act('set', {
        // Call the backend action
        field: label,
        value: valueToCheck,
      });
    }
  };
  return (
    <Stack vertical>
      <Stack.Item grow>{currentValue}</Stack.Item>
      <Stack.Item>
        <Input
          onEnter={(value) => WasChanged(value)}
          onBlur={(value) => WasChanged(value)}
          placeholder={currentValue}
        />
      </Stack.Item>
    </Stack>
  );
};

export const ChameleonCardForge = (props) => {
  const { data } = useBackend<Data>();
  const {
    registered_name,
    assignment,
    trim_override,
    age,
    is_wallet_spoofing,
    gender_presented,
  } = data;

  return (
    <Window width={500} height={300} theme="syndicate">
      <Window.Content fitted>
        <Stack inlineFlex justify="space-between">
          <EntrySection
            label="registered_name"
            value={registered_name}
          />
          <EntrySection
            label="assignment"
            value={assignment}
          />
          <EntrySection
            label="trim_override"
            value={trim_override}
          />
          <EntrySection
            label="age"
            value={age}
          />
          <EntrySection
            label="is_wallet_spoofing"
            value={is_wallet_spoofing}
          />
          <EntrySection
          label="gender_presented"
          value={gender_presented}
          />
        </Stack>
      </Window.Content>
    </Window>
  );
};
