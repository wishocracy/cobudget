-- CreateEnum
CREATE TYPE "ExpenseStatus" AS ENUM ('SUBMITTED', 'PAID', 'REJECTED');

-- CreateEnum
CREATE TYPE "FieldType" AS ENUM ('TEXT', 'MULTILINE_TEXT', 'BOOLEAN', 'ENUM', 'FILE');

-- CreateEnum
CREATE TYPE "RegistrationPolicy" AS ENUM ('OPEN', 'REQUEST_TO_JOIN', 'INVITE_ONLY');

-- CreateEnum
CREATE TYPE "Visibility" AS ENUM ('PUBLIC', 'HIDDEN');

-- CreateEnum
CREATE TYPE "AllocationType" AS ENUM ('ADD', 'SET');

-- CreateEnum
CREATE TYPE "DirectFundingType" AS ENUM ('DONATION', 'EXCHANGE');

-- CreateEnum
CREATE TYPE "BudgetItemType" AS ENUM ('INCOME', 'EXPENSE');

-- CreateEnum
CREATE TYPE "FlagType" AS ENUM ('RAISE_FLAG', 'RESOLVE_FLAG', 'ALL_GOOD_FLAG');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "username" TEXT,
    "email" TEXT,
    "name" TEXT,
    "verifiedEmail" BOOLEAN NOT NULL DEFAULT false,
    "emailVerified" TIMESTAMP(3),
    "mailUpdates" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "image" TEXT,
    "facebookId" TEXT,
    "googleId" TEXT,
    "acceptedTermsAt" TIMESTAMP(3),
    "isSuperAdmin" BOOLEAN DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailSettings" (
    "id" TEXT NOT NULL,
    "commentMentions" BOOLEAN NOT NULL DEFAULT true,
    "commentBecauseCocreator" BOOLEAN NOT NULL DEFAULT true,
    "commentBecauseCommented" BOOLEAN NOT NULL DEFAULT true,
    "allocatedToYou" BOOLEAN NOT NULL DEFAULT true,
    "refundedBecauseBucketCancelled" BOOLEAN NOT NULL DEFAULT true,
    "bucketPublishedInRound" BOOLEAN NOT NULL DEFAULT false,
    "contributionToYourBucket" BOOLEAN NOT NULL DEFAULT true,
    "roundJoinRequest" BOOLEAN NOT NULL DEFAULT true,
    "userId" TEXT NOT NULL,

    CONSTRAINT "EmailSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExpenseReceipt" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "amount" INTEGER NOT NULL,
    "attachment" TEXT,
    "expenseId" TEXT,

    CONSTRAINT "ExpenseReceipt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Expense" (
    "id" TEXT NOT NULL,
    "bucketId" TEXT,
    "title" TEXT NOT NULL,
    "recipientName" TEXT NOT NULL,
    "recipientEmail" TEXT NOT NULL,
    "swiftCode" TEXT DEFAULT E'',
    "iban" TEXT DEFAULT E'',
    "country" TEXT NOT NULL DEFAULT E'',
    "city" TEXT NOT NULL DEFAULT E'',
    "recipientAddress" TEXT NOT NULL,
    "recipientPostalCode" TEXT NOT NULL,
    "submittedBy" TEXT NOT NULL,
    "status" "ExpenseStatus" NOT NULL DEFAULT E'SUBMITTED',

    CONSTRAINT "Expense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrgMember" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "bio" TEXT,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "discourseUsername" TEXT,
    "discourseApiKey" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isApproved" BOOLEAN NOT NULL DEFAULT true,
    "hasJoined" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "OrgMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CollectionMember" (
    "id" TEXT NOT NULL,
    "collectionId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isModerator" BOOLEAN NOT NULL DEFAULT false,
    "bio" TEXT,
    "hasJoined" BOOLEAN NOT NULL DEFAULT true,
    "isApproved" BOOLEAN NOT NULL DEFAULT false,
    "isRemoved" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "incomingAccountId" TEXT,
    "outgoingAccountId" TEXT,
    "statusAccountId" TEXT,

    CONSTRAINT "CollectionMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "info" TEXT,
    "logo" TEXT,
    "inviteNonce" INTEGER,
    "finishedTodos" BOOLEAN NOT NULL DEFAULT false,
    "experimentalFeatures" BOOLEAN NOT NULL DEFAULT false,
    "stripeCustomerId" TEXT,
    "stripeSubscriptionId" TEXT,
    "stripePriceId" TEXT,
    "stripeCurrentPeriodEnd" TIMESTAMP(3),
    "registrationPolicy" "RegistrationPolicy" DEFAULT E'OPEN',
    "visibility" "Visibility" DEFAULT E'PUBLIC',

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Collection" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "singleCollection" BOOLEAN NOT NULL DEFAULT false,
    "title" TEXT NOT NULL,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "info" TEXT,
    "about" TEXT,
    "color" TEXT,
    "registrationPolicy" "RegistrationPolicy" NOT NULL,
    "currency" TEXT NOT NULL,
    "visibility" "Visibility" NOT NULL DEFAULT E'PUBLIC',
    "maxAmountToBucketPerUser" INTEGER,
    "bucketCreationCloses" TIMESTAMP(3),
    "grantingOpens" TIMESTAMP(3),
    "grantingCloses" TIMESTAMP(3),
    "allowStretchGoals" BOOLEAN,
    "stripeAccountId" TEXT,
    "directFundingEnabled" BOOLEAN NOT NULL DEFAULT false,
    "directFundingTerms" TEXT NOT NULL DEFAULT E'',
    "bucketReviewIsOpen" BOOLEAN,
    "discourseCategoryId" INTEGER,
    "canCocreatorStartFunding" BOOLEAN DEFAULT false,
    "canCocreatorEditOpenBuckets" BOOLEAN DEFAULT false,
    "openCollectiveId" TEXT,
    "openCollectiveProjectId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "statusAccountId" TEXT,
    "inviteNonce" INTEGER,

    CONSTRAINT "Collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "collectionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Guideline" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "position" DOUBLE PRECISION NOT NULL,
    "collectionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Guideline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Field" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" "FieldType" NOT NULL,
    "limit" INTEGER,
    "isRequired" BOOLEAN NOT NULL,
    "position" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "collectionId" TEXT NOT NULL,

    CONSTRAINT "Field_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FieldValue" (
    "id" TEXT NOT NULL,
    "fieldId" TEXT,
    "value" JSONB NOT NULL,
    "bucketId" TEXT NOT NULL,

    CONSTRAINT "FieldValue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bucket" (
    "id" TEXT NOT NULL,
    "collectionId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "summary" TEXT,
    "approvedAt" TIMESTAMP(3),
    "publishedAt" TIMESTAMP(3),
    "fundedAt" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "archivedAt" TIMESTAMP(3),
    "readyForFundingAt" TIMESTAMP(3),
    "directFundingEnabled" BOOLEAN NOT NULL DEFAULT false,
    "directFundingType" "DirectFundingType" NOT NULL DEFAULT E'DONATION',
    "exchangeDescription" TEXT NOT NULL DEFAULT E'',
    "exchangeMinimumContribution" INTEGER NOT NULL DEFAULT 0,
    "exchangeVat" INTEGER,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "discourseTopicId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "statusAccountId" TEXT,
    "outgoingAccountId" TEXT,
    "percentageFunded" DOUBLE PRECISION DEFAULT 0,
    "contributionsCount" INTEGER DEFAULT 0,

    CONSTRAINT "Bucket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Image" (
    "id" TEXT NOT NULL,
    "small" TEXT,
    "large" TEXT,
    "bucketId" TEXT,

    CONSTRAINT "Image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BudgetItem" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "min" INTEGER NOT NULL,
    "max" INTEGER,
    "type" "BudgetItemType" NOT NULL,
    "bucketId" TEXT,

    CONSTRAINT "BudgetItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "isLog" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "collMemberId" TEXT NOT NULL,
    "bucketId" TEXT NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Flag" (
    "id" TEXT NOT NULL,
    "guidelineId" TEXT,
    "comment" TEXT,
    "collMemberId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "FlagType" NOT NULL,
    "resolvingFlagId" TEXT,
    "bucketId" TEXT NOT NULL,

    CONSTRAINT "Flag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Allocation" (
    "id" TEXT NOT NULL,
    "collectionId" TEXT NOT NULL,
    "collectionMemberId" TEXT NOT NULL,
    "allocatedById" TEXT,
    "amount" INTEGER NOT NULL,
    "amountBefore" INTEGER,
    "allocationType" "AllocationType" NOT NULL DEFAULT E'ADD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stripeSessionId" TEXT,

    CONSTRAINT "Allocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contribution" (
    "id" TEXT NOT NULL,
    "collectionId" TEXT NOT NULL,
    "collectionMemberId" TEXT NOT NULL,
    "bucketId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "amountBefore" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stripeSessionId" TEXT,

    CONSTRAINT "Contribution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DiscourseConfig" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "apiKey" TEXT NOT NULL,
    "dreamsCategoryId" INTEGER NOT NULL,
    "minPostLength" INTEGER NOT NULL,
    "organizationId" TEXT NOT NULL,

    CONSTRAINT "DiscourseConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT,
    "collectionMemberId" TEXT,
    "collectionId" TEXT,
    "fromAccountId" TEXT NOT NULL,
    "toAccountId" TEXT NOT NULL,
    "stripeSessionId" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuperAdminSession" (
    "id" TEXT NOT NULL,
    "start" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end" TIMESTAMP(3),
    "duration" INTEGER NOT NULL,
    "adminId" TEXT NOT NULL,

    CONSTRAINT "SuperAdminSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_BucketToRoundMember" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_BucketToTag" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_facebookId_key" ON "User"("facebookId");

-- CreateIndex
CREATE UNIQUE INDEX "User_googleId_key" ON "User"("googleId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailSettings_userId_key" ON "EmailSettings"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "OrgMember_organizationId_userId_key" ON "OrgMember"("organizationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "CollectionMember_incomingAccountId_key" ON "CollectionMember"("incomingAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "CollectionMember_outgoingAccountId_key" ON "CollectionMember"("outgoingAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "CollectionMember_statusAccountId_key" ON "CollectionMember"("statusAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "CollectionMember_userId_collectionId_key" ON "CollectionMember"("userId", "collectionId");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_slug_key" ON "Organization"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_stripeCustomerId_key" ON "Organization"("stripeCustomerId");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_stripeSubscriptionId_key" ON "Organization"("stripeSubscriptionId");

-- CreateIndex
CREATE UNIQUE INDEX "Collection_statusAccountId_key" ON "Collection"("statusAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Collection_organizationId_slug_key" ON "Collection"("organizationId", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_collectionId_value_key" ON "Tag"("collectionId", "value");

-- CreateIndex
CREATE UNIQUE INDEX "FieldValue_bucketId_fieldId_key" ON "FieldValue"("bucketId", "fieldId");

-- CreateIndex
CREATE UNIQUE INDEX "Bucket_statusAccountId_key" ON "Bucket"("statusAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Bucket_outgoingAccountId_key" ON "Bucket"("outgoingAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Flag_resolvingFlagId_key" ON "Flag"("resolvingFlagId");

-- CreateIndex
CREATE UNIQUE INDEX "DiscourseConfig_organizationId_key" ON "DiscourseConfig"("organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "_BucketToRoundMember_AB_unique" ON "_BucketToRoundMember"("A", "B");

-- CreateIndex
CREATE INDEX "_BucketToRoundMember_B_index" ON "_BucketToRoundMember"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_BucketToTag_AB_unique" ON "_BucketToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_BucketToTag_B_index" ON "_BucketToTag"("B");

-- AddForeignKey
ALTER TABLE "EmailSettings" ADD CONSTRAINT "EmailSettings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpenseReceipt" ADD CONSTRAINT "ExpenseReceipt_expenseId_fkey" FOREIGN KEY ("expenseId") REFERENCES "Expense"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Expense" ADD CONSTRAINT "Expense_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrgMember" ADD CONSTRAINT "OrgMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrgMember" ADD CONSTRAINT "OrgMember_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectionMember" ADD CONSTRAINT "CollectionMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectionMember" ADD CONSTRAINT "CollectionMember_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectionMember" ADD CONSTRAINT "CollectionMember_incomingAccountId_fkey" FOREIGN KEY ("incomingAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectionMember" ADD CONSTRAINT "CollectionMember_statusAccountId_fkey" FOREIGN KEY ("statusAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectionMember" ADD CONSTRAINT "CollectionMember_outgoingAccountId_fkey" FOREIGN KEY ("outgoingAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collection" ADD CONSTRAINT "Collection_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collection" ADD CONSTRAINT "Collection_statusAccountId_fkey" FOREIGN KEY ("statusAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Guideline" ADD CONSTRAINT "Guideline_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Field" ADD CONSTRAINT "Field_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FieldValue" ADD CONSTRAINT "FieldValue_fieldId_fkey" FOREIGN KEY ("fieldId") REFERENCES "Field"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FieldValue" ADD CONSTRAINT "FieldValue_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bucket" ADD CONSTRAINT "Bucket_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bucket" ADD CONSTRAINT "Bucket_statusAccountId_fkey" FOREIGN KEY ("statusAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bucket" ADD CONSTRAINT "Bucket_outgoingAccountId_fkey" FOREIGN KEY ("outgoingAccountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Image" ADD CONSTRAINT "Image_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BudgetItem" ADD CONSTRAINT "BudgetItem_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_collMemberId_fkey" FOREIGN KEY ("collMemberId") REFERENCES "CollectionMember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Flag" ADD CONSTRAINT "Flag_collMemberId_fkey" FOREIGN KEY ("collMemberId") REFERENCES "CollectionMember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Flag" ADD CONSTRAINT "Flag_guidelineId_fkey" FOREIGN KEY ("guidelineId") REFERENCES "Guideline"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Flag" ADD CONSTRAINT "Flag_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Flag" ADD CONSTRAINT "Flag_resolvingFlagId_fkey" FOREIGN KEY ("resolvingFlagId") REFERENCES "Flag"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Allocation" ADD CONSTRAINT "Allocation_collectionMemberId_fkey" FOREIGN KEY ("collectionMemberId") REFERENCES "CollectionMember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Allocation" ADD CONSTRAINT "Allocation_allocatedById_fkey" FOREIGN KEY ("allocatedById") REFERENCES "CollectionMember"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Allocation" ADD CONSTRAINT "Allocation_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contribution" ADD CONSTRAINT "Contribution_collectionMemberId_fkey" FOREIGN KEY ("collectionMemberId") REFERENCES "CollectionMember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contribution" ADD CONSTRAINT "Contribution_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contribution" ADD CONSTRAINT "Contribution_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "Bucket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscourseConfig" ADD CONSTRAINT "DiscourseConfig_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_collectionMemberId_fkey" FOREIGN KEY ("collectionMemberId") REFERENCES "CollectionMember"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES "Collection"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_fromAccountId_fkey" FOREIGN KEY ("fromAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_toAccountId_fkey" FOREIGN KEY ("toAccountId") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BucketToRoundMember" ADD CONSTRAINT "_BucketToRoundMember_A_fkey" FOREIGN KEY ("A") REFERENCES "Bucket"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BucketToRoundMember" ADD CONSTRAINT "_BucketToRoundMember_B_fkey" FOREIGN KEY ("B") REFERENCES "CollectionMember"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BucketToTag" ADD CONSTRAINT "_BucketToTag_A_fkey" FOREIGN KEY ("A") REFERENCES "Bucket"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BucketToTag" ADD CONSTRAINT "_BucketToTag_B_fkey" FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
