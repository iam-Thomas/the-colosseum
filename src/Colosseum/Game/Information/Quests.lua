RegInit(function()
    Colosseum_CreateQuests()
end)

function Colosseum_CreateQuests()
    local quest = CreateQuest()
    
    QuestSetTitle(quest, "Keywords")
    QuestSetDescription(quest, "MANY KEYWORDS!")
    QuestSetDiscovered(quest, true)
    --QuestSetRequired(quest, true)
    QuestSetEnabled(quest, true)
    
    local questItem = QuestCreateItem(quest)
    QuestItemSetDescription(questItem, "Empowered: Empowered units restore 1 mana per second and have 25% increased attack speed. In addition, many abilities have empowered effects.")
    -- questItem = QuestCreateItem(quest)
    -- QuestItemSetDescription(questItem, "Tenacious: Tenacious units are immune to stuns and knockbacks. In addition, Tenacious units take 15% damage from all sources.")
    -- questItem = QuestCreateItem(quest)
    -- QuestItemSetDescription(questItem, "Elusive: Elusive units are dispel most magical effects and have 40% increased movement speed.")

    -- questItem = QuestCreateItem(quest)
    -- QuestItemSetDescription(questItem, "Reckless: Reckless units have 20% increased movement speed. In addition, they deal and take 20% increased damage.")

    -- questItem = QuestCreateItem(quest)
    -- QuestItemSetDescription(questItem, "Burnt: Burnt units move 10% slower and attack 25% slower. In addition, they receive 33% less healing from all sources.")
    -- -- questItem = QuestCreateItem(quest)
    -- -- QuestItemSetDescription(questItem, "Slowed?: Burnt units move 10% slower and attack 25% slower. In addition, they receive 33% less healing from all sources.")
    -- questItem = QuestCreateItem(quest)
    -- QuestItemSetDescription(questItem, "Fear: Feared units deal 25% less damage with basic attacks.")
end