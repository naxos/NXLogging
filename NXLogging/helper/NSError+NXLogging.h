// -----------------------------------------------------------------------------
// This file is part of NXLogging.
//
// Copyright © 2016 Naxos Software Solutions GmbH. All rights reserved.
//
// Author: Martin Schaefer <martin.schaefer@naxos-software.de>
//
// NXLogging is licensed under the Simplified BSD License
// -----------------------------------------------------------------------------
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

/**
 * A category of NSError which provides some methods
 * to retrieve info for log output and comes with a set
 * of convenience initializers.
 */
@interface NSError (NXLogging)

#pragma mark - Properties
/// @name Properties

/** 
 * Get a string representing this error and the underlying errors.
 * The errors will be separated by a new line character.
 */
@property (nonatomic, readonly) NSString *logTrace;

/** 
 * Get a simple description on this error consisting of its
 * localizedDescription, domain, and code
 */
@property (nonatomic, readonly) NSString *logInfo;

#pragma mark - Class method to get the default error domain of the application
/// @name Class methods

/**
 * The application error domain derived from the application's bundle identifier.
 */
+ (NSString *)applicationErrorDomain;

#pragma mark - Static convenience initializers (default application error domain)
/// @name Static initializers

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @result An NSError object for the applicationErrorDomain with the specified error code and the dictionary with the description.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @result An NSError object for the applicationErrorDomain with the specified error code and the dictionary with the description and reason.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @result An NSError object for the applicationErrorDomain with the specified error code and the dictionary with the description and suggestion.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSUnderlyingErrorKey.
 * @result An NSError object for the applicationErrorDomain with the specified error code and the dictionary with the description and the underlying error.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error code and the dictionary with the description, reason and the underlying error.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error code and the dictionary with the description, suggestion and the underlying error.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error code and the dictionary with the description, reason, suggestion and the underlying error.
 */
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion underlyingError:(NSError *)error;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param code The error code for the error.
 * @param dict The userInfo dictionary for the error. userInfo may be nil.
 * @result An NSError object for the applicationErrorDomain with the specified error code and the dictionary of arbitrary data userInfo.
 */
+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;

#pragma mark - Static convenience initializers (custom error domain)

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @result An NSError object for the applicationErrorDomain with the specified error domain, code code and the dictionary with the description.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @result An NSError object for the applicationErrorDomain with the specified error domain, code and the dictionary with the description and reason.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @result An NSError object for the applicationErrorDomain with the specified error domain, code and the dictionary with the description and suggestion.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion;

/**
 * Convenience initializer. Uses applicationErrorDomain as the error domain.
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSUnderlyingErrorKey.
 * @result An NSError object for the applicationErrorDomain with the specified error domain, code and the dictionary with the description and the underlying error.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error domain, code and the dictionary with the description, reason and the underlying error.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error domain, code and the dictionary with the description, suggestion and the underlying error.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion underlyingError:(NSError *)error;

/**
 * Convenience initializer
 *
 * @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil.
 * @param code The error code for the error.
 * @param description The desription will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param reason The reason for the failure will be stored in the userInfo dictionary with the key NSLocalizedFailureReasonErrorKey.
 * @param suggestion The recovery suggestion, which will be stored in the userInfo dictionary with the key NSLocalizedDescriptionKey.
 * @param error The underlyingError will be stored in the userInfo dictionary with the key NSLocalizedRecoverySuggestionErrorKey.
 * @result An NSError object for domain with the specified error domain, code and the dictionary with the description, reason, suggestion and the underlying error.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion underlyingError:(NSError *)error;

@end
