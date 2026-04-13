import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_attack_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification_credential_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';

About buildAbout() => About(
  slug: Slug('about_me'),
  sourcePath: SingleLineText('sources_of_truth/about_me.md'),
  title: Title('About Me'),
  whoIAmProfessionally: NonEmptyText('Software engineer.'),
  currentPositioning: NonEmptyText('Building maintainable software.'),
  developmentBackground: NonEmptyText('Flutter and backend development.'),
  securityDirection: NonEmptyText('Growing in secure engineering.'),
  strengthsAndWorkingStyle: <NonEmptyText>[
    NonEmptyText('Structured and pragmatic.'),
  ],
  selectedSkillsAndTools: <AboutSkillGroup>[
    AboutSkillGroup(
      label: SingleLineText('Core'),
      items: <SingleLineText>[
        SingleLineText('Flutter'),
      ],
    ),
  ],
  howIBuildSoftware: NonEmptyText(
    'I build iteratively and document trade-offs.',
  ),
  howDevelopmentAndSecurityConnect: NonEmptyText(
    'Security is part of implementation quality.',
  ),
);

About buildInvalidAbout() => About(
  slug: Slug('Invalid Slug'),
  sourcePath: SingleLineText('sources_of_truth/about_me.md'),
  title: Title('About Me'),
  whoIAmProfessionally: NonEmptyText('Software engineer.'),
  currentPositioning: NonEmptyText('Building maintainable software.'),
  developmentBackground: NonEmptyText('Flutter and backend development.'),
  securityDirection: NonEmptyText('Growing in secure engineering.'),
  strengthsAndWorkingStyle: <NonEmptyText>[
    NonEmptyText('Structured and pragmatic.'),
  ],
  selectedSkillsAndTools: <AboutSkillGroup>[
    AboutSkillGroup(
      label: SingleLineText('Core'),
      items: <SingleLineText>[
        SingleLineText('Flutter'),
      ],
    ),
  ],
  howIBuildSoftware: NonEmptyText(
    'I build iteratively and document trade-offs.',
  ),
  howDevelopmentAndSecurityConnect: NonEmptyText(
    'Security is part of implementation quality.',
  ),
);

Project buildProject() => Project(
  slug: Slug('pami'),
  sourcePath: SingleLineText('sources_of_truth/projects/pami.md'),
  startDate: YearMonth('2024-01'),
  isOngoing: true,
  title: Title('PAMi'),
  summary: NonEmptyText('A portfolio proof project.'),
  roleAndScope: NonEmptyText('Designed and implemented the system.'),
  productContext: NonEmptyText('Created to validate architecture decisions.'),
  stack: <SingleLineText>[
    SingleLineText('Flutter'),
  ],
  implementation: NonEmptyText(
    'Layered architecture with explicit validation.',
  ),
  outcomes: <NonEmptyText>[
    NonEmptyText('Delivered a maintainable baseline.'),
  ],
  thumbnailPath: AssetPath('assets/media/content/projects/pami/thumbnail.png'),
  links: <LinkReference>[
    LinkReference(
      label: SingleLineText('Repository'),
      url: UrlValue('https://example.com/project'),
    ),
  ],
);

CaseStudy buildCaseStudy() => CaseStudy(
  slug: Slug('cutting_edge'),
  sourcePath: SingleLineText('sources_of_truth/case_studies/cutting_edge.md'),
  title: Title('Cutting Edge'),
  summary: NonEmptyText('A security case study.'),
  incidentOverview: NonEmptyText('Overview of the case.'),
  adversaryObjectives: NonEmptyText('Objectives of the adversary.'),
  attackMapping: CaseStudyAttackMapping(
    tactics: <NonEmptyText>[
      NonEmptyText('Initial access'),
    ],
    techniques: <NonEmptyText>[
      NonEmptyText('Spearphishing link'),
    ],
    procedureExamples: <NonEmptyText>[
      NonEmptyText('Sent a malicious document.'),
    ],
  ),
  defensiveAnalysis: NonEmptyText('Detection and response review.'),
  lessonsLearned: <NonEmptyText>[
    NonEmptyText('Validate assumptions early.'),
  ],
  reflection: NonEmptyText('Useful lessons for defensive engineering.'),
  references: <LinkReference>[
    LinkReference(
      label: SingleLineText('Reference'),
      url: UrlValue('https://example.com/case-study'),
    ),
  ],
);

Certification buildCertification() => Certification(
  slug: Slug('security_plus'),
  sourcePath: SingleLineText(
    'sources_of_truth/certifications/security_plus.md',
  ),
  earnedDate: YearMonth('2024-05'),
  title: Title('Security+'),
  summary: NonEmptyText('A certification summary.'),
  credentialDetails: CertificationCredentialDetails(
    issuer: SingleLineText('CompTIA'),
    credentialType: SingleLineText('Certification'),
    level: SingleLineText('Associate'),
  ),
  knowledgeAreas: <NonEmptyText>[
    NonEmptyText('Threats and vulnerabilities.'),
  ],
  learningOutcomes: <NonEmptyText>[
    NonEmptyText('Strengthened baseline security knowledge.'),
  ],
);

Course buildCourse() => Course(
  slug: Slug('google_networking'),
  sourcePath: SingleLineText('sources_of_truth/courses/google_networking.md'),
  title: Title('Google Networking'),
  summary: NonEmptyText('A networking course.'),
  courseDetails: CourseDetails(
    provider: SingleLineText('Google'),
    platform: SingleLineText('Coursera'),
    format: SingleLineText('Online'),
    level: SingleLineText('Beginner'),
  ),
  topicsCovered: <NonEmptyText>[
    NonEmptyText('Networking fundamentals.'),
  ],
  relevance: <NonEmptyText>[
    NonEmptyText('Supports infrastructure understanding.'),
  ],
);

Resume buildResume() => Resume(
  slug: Slug('resume'),
  sourcePath: SingleLineText('sources_of_truth/resume.md'),
  name: SingleLineText('Carlos Mendez'),
  location: SingleLineText('Madrid, Spain'),
  summary: NonEmptyText('Software engineer with structured delivery habits.'),
  contactLinks: <LinkReference>[
    LinkReference(
      label: SingleLineText('LinkedIn'),
      url: UrlValue('https://example.com/linkedin'),
    ),
  ],
  coreSkills: <ResumeSkillGroup>[
    ResumeSkillGroup(
      label: SingleLineText('Engineering'),
      items: <SingleLineText>[
        SingleLineText('Flutter'),
      ],
    ),
  ],
  professionalExperience: <ResumeExperienceItem>[
    ResumeExperienceItem(
      title: Title('Software Engineer'),
      organization: SingleLineText('Example Org'),
      location: SingleLineText('Remote'),
      startDate: YearMonth('2023-01'),
      isOngoing: true,
      highlights: <NonEmptyText>[
        NonEmptyText('Built maintainable application flows.'),
      ],
    ),
  ],
  education: <ResumeEducationItem>[
    ResumeEducationItem(
      title: Title('Computer Science'),
      institution: SingleLineText('Example University'),
      location: SingleLineText('Madrid, Spain'),
      startDate: YearMonth('2018-09'),
      endDate: YearMonth('2022-06'),
    ),
  ],
  languages: <ResumeLanguageItem>[
    ResumeLanguageItem(
      language: SingleLineText('English'),
      proficiency: LanguageProficiency.c1,
    ),
  ],
  resumePdfPath: DocumentPath('assets/documents/resume/resume.pdf'),
);
