//
//  Pokemon.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/13/20.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let baseExp: Int
    let weight: Int
    let height: Int
    let abilities: [Ability]
    let species: Species
    let sprites: Sprites
    let allMoves: [Moves]
    let types: [Type]
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case baseExp = "base_experience"
        case weight
        case abilities
        case height
        case species
        case sprites
        case allMoves = "moves"
        case types
    }
}

struct Species: Decodable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

struct Sprites: Decodable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: URL?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

struct Moves: Decodable {
    let move: String?
    let url: String?
    let details: [Detail]?
    
    enum CodingKeys: String, CodingKey {
        case move
        case details = "version_group_details"
    }
    enum MoveCodingKeys: String, CodingKey {
       case name
       case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let moveContainer = try container.nestedContainer(keyedBy: MoveCodingKeys.self, forKey: .move)
        self.move = try moveContainer.decodeIfPresent(String.self, forKey: .name)
        self.url = try moveContainer.decodeIfPresent(String.self, forKey: .url)
        self.details = try container.decodeIfPresent([Detail].self, forKey: .details)
    }
    
    struct Detail: Decodable {
        let levelLearnedAt: Int
        let moveName: String?
        let moveURL: String?
        let versionName: String?
        let versionURL: String?

        enum DetailCodingKeys: String, CodingKey {
            case levelLearnedAt = "level_learned_at"
            case moveLearnMethod = "move_learn_method"
            case versionGroup = "version_group"
        }
        
        enum LearnMethodCodingKeys: String, CodingKey {
            case name
            case url
        }
        
        enum VersionCodingKeys: String, CodingKey {
            case name
            case url
        }
        
        init(from decoder: Decoder) throws {
            let detailContainer = try decoder.container(keyedBy: DetailCodingKeys.self)
            let learnMethodContainer = try detailContainer.nestedContainer(keyedBy: LearnMethodCodingKeys.self, forKey: .moveLearnMethod)
            let versionGroupContainer = try detailContainer.nestedContainer(keyedBy: VersionCodingKeys.self, forKey: .versionGroup)
            self.levelLearnedAt = try detailContainer.decode(Int.self, forKey: .levelLearnedAt)
            self.moveName = try learnMethodContainer.decodeIfPresent(String.self, forKey: .name)
            self.moveURL = try learnMethodContainer.decodeIfPresent(String.self, forKey: .url)
            self.versionName = try versionGroupContainer.decodeIfPresent(String.self, forKey: .name)
            self.versionURL = try versionGroupContainer.decodeIfPresent(String.self, forKey: .url)
        }
    }
}



struct Ability: Decodable {
    let isHidden: Bool
    let slot: Int
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case ability
        case slot
    }
    
    enum AbilityCodingKeys: String, CodingKey {
        case name
        case url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let abilityContainer = try container.nestedContainer(keyedBy: AbilityCodingKeys.self, forKey: .ability)
        self.name = try abilityContainer.decode(String.self, forKey: .name)
        self.url = try abilityContainer.decode(String.self, forKey: .url)
        self.isHidden = try container.decode(Bool.self, forKey: .isHidden)
        self.slot = try container.decode(Int.self, forKey: .slot)
    }
}

struct Type: Decodable{
    let name: String
    
    enum CodingKeys: String,CodingKey{
        case type
    }
    enum TypeCodingKeys: String, CodingKey{
        case name
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typecontainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
        self.name = try typecontainer.decode(String.self, forKey: .name)
    }
}

