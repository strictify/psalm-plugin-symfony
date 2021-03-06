@symfony-common
Feature: Form config

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm errorLevel="1">
        <projectFiles>
          <directory name="."/>
          <ignoreFiles> <directory name="../../vendor"/> </ignoreFiles>
        </projectFiles>

        <plugins>
          <pluginClass class="Psalm\SymfonyPsalmPlugin\Plugin"/>
        </plugins>
        <issueHandlers>
          <UnusedVariable errorLevel="info"/>
        </issueHandlers>
      </psalm>
      """
  Scenario: FormConfigInterface::getData() will return ?T
    Given I have the following code
          """
      <?php

      class User {}

      use Symfony\Component\Form\AbstractType;
      use Symfony\Component\Form\FormBuilderInterface;

      /** @extends AbstractType<User> */
      class UserType extends AbstractType
      {
          public function buildForm(FormBuilderInterface $builder, array $options): void
          {
              $data = $builder->getData();
              /** @psalm-trace $data */
          }
      }
      """
    When I run Psalm
    Then I see these errors
      | Type  | Message                                                         |
      | Trace | $data: User\|null                                               |
    And I see no other errors

